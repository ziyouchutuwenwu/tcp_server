-module(tcp_server_handler).
-behaviour(gen_server).

-export([start_link/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(socket_info_record, {config_behavior, name, server_socket, client_socket, client_ip, client_port, recv_timer_ref, recv_timeout_count}).

start_link(Name, LSock, ConfigBehavior) ->
  gen_server:start_link(?MODULE, [Name, LSock, ConfigBehavior], []).

init([Name, Socket, ConfigBehavior]) ->
  {ok, #socket_info_record{config_behavior = ConfigBehavior, name = Name, server_socket = Socket}, 0}.

handle_call(Msg, _From, State) ->
  {reply, {ok, Msg}, State}.

%% 发数据包
handle_cast({send_socket_msg, Cmd, InfoBin}, #socket_info_record{config_behavior = ConfigBehavior, client_socket = Socket} = State) ->
  tcp_server_send:send_data_by_socket(Socket, Cmd, InfoBin, ConfigBehavior),
  {noreply, State};

handle_cast(stop, State) ->
  {stop, normal, State}.

handle_info({tcp, Socket, Data}, #socket_info_record{config_behavior = ConfigBehavior, recv_timer_ref = OldRecvTimerRef} = State) ->
  OptionsModule = ConfigBehavior:get_socket_options_module(),

  erlang:cancel_timer(OldRecvTimerRef),
  NewRecvTimerRef = erlang:send_after(OptionsModule:get_tcp_recv_timeout(), self(), recv_time_out),

%%	收到数据
  SocketCodecModule = ConfigBehavior:get_socket_codec_module(),
  DataBin = SocketCodecModule:decode(Data),

  SocketUnpackModule = ConfigBehavior:get_socket_package_module(),
  {Cmd, InfoBin} = SocketUnpackModule:unpack(DataBin),

  SocketHandlerModule = ConfigBehavior:get_socket_handler_module(),
  SocketHandlerModule:on_client_data(Socket, Cmd, InfoBin),

  {noreply, State#socket_info_record{recv_timer_ref = NewRecvTimerRef}};

handle_info({tcp_passive, Socket}, #socket_info_record{config_behavior = ConfigBehavior} = State) ->
  OptionsModule = ConfigBehavior:get_socket_options_module(),
  inet:setopts(Socket, [{active, OptionsModule:get_active_count()}]),
  {noreply, State};

handle_info({tcp_closed, _Socket}, #socket_info_record{config_behavior = ConfigBehavior, client_ip = ClientIp, client_port = ClientPort} = State) ->
  %%客户端断开连接
  SocketHandlerMod = ConfigBehavior:get_socket_handler_module(),
  SocketHandlerMod:on_disconnected(ClientIp, ClientPort),

  {stop, normal, State};

handle_info({tcp_error, _Socket, Reason}, State) ->
  {stop, Reason, State};

%% init结束的消息
handle_info(timeout, #socket_info_record{config_behavior = ConfigBehavior, name = Name, server_socket = LSock} = State) ->
  OptionsModule = ConfigBehavior:get_socket_options_module(),

%%     LSock的一些属性，会直接复制给ClientSocket，这个在prim_inet模块的accept函数里面有 
  inet:setopts(LSock, [{active, OptionsModule:get_active_count()}]),
  case gen_tcp:accept(LSock, OptionsModule:get_tcp_conn_timeout()) of
    {ok, ClientSocket} ->
      RecvTimeoutCount = 0,
      RecvTimerRef = erlang:send_after(OptionsModule:get_tcp_recv_timeout(), self(), recv_time_out),

      %%客户端连接成功
      {ok, {ClientIp, ClientPort}} = inet:peername(ClientSocket),
      ClientIpStr = inet:ntoa(ClientIp),
      SocketHandlerModule = ConfigBehavior:get_socket_handler_module(),
      SocketHandlerModule:on_client_connected(ClientSocket, ClientIpStr, ClientPort),

      tcp_server_handler_sup:start_child(Name),
      {noreply, State#socket_info_record{
        client_socket = ClientSocket, client_ip = ClientIpStr, client_port = ClientPort,
        recv_timer_ref = RecvTimerRef, recv_timeout_count = RecvTimeoutCount
      }};
    {error, Reason} ->
      tcp_server_handler_sup:start_child(Name),
      {stop, Reason, State}
  end;

handle_info(recv_time_out, #socket_info_record{config_behavior = ConfigBehavior, recv_timer_ref = RecvTimerRef, recv_timeout_count = RecvTimeoutCount} = State) ->
  OptionsModule = ConfigBehavior:get_socket_options_module(),

  NewRecvTimeoutCount = RecvTimeoutCount + 1,
  RecvTimeOutLimit = OptionsModule:get_tcp_recv_timeout_count(),

  if
%%         超过最大限制
    NewRecvTimeoutCount >= RecvTimeOutLimit ->
      erlang:cancel_timer(RecvTimerRef),
      {stop, recv_timeout, State#socket_info_record{recv_timeout_count = NewRecvTimeoutCount}};
    true ->
      erlang:cancel_timer(RecvTimerRef),
      NewRecvTimerRef = erlang:send_after(OptionsModule:get_tcp_recv_timeout(), self(), recv_time_out),
      {noreply, State#socket_info_record{recv_timeout_count = NewRecvTimeoutCount, recv_timer_ref = NewRecvTimerRef}}
  end;

handle_info(_Info, StateData) ->
  {noreply, StateData}.

terminate(_Reason, #socket_info_record{client_socket = Socket}) ->
  io:format("process terminated~p ~p ~n", [self(), _Reason]),
  (catch gen_tcp:close(Socket)),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.