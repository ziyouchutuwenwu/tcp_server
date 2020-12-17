-module(tcp_server_listener).
-behaviour(gen_server).

-export([start_link/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(server_state, {config_behavior, server_port, name}).

start_link(Name, Port, ConfigBehavior) ->
  State = #server_state{config_behavior = ConfigBehavior, server_port = Port, name = Name},
  gen_server:start_link(?MODULE, State, []).

init(State = #server_state{config_behavior = ConfigBehavior, server_port = Port, name = Name}) ->

  OptionsModule = ConfigBehavior:get_socket_options_module(),
  Options = OptionsModule:get_tcp_options(),

  case gen_tcp:listen(Port, Options) of
    {ok, LSocket} ->
      case tcp_server_handler_sup:start_link(Name, LSocket, ConfigBehavior) of
        {ok, _Pid} ->
          tcp_server_handler_sup:start_child(Name),
          {ok, State};
        {error, Reason} ->
          {stop, {create_tcp_handler, Reason}}
      end;
    {error, Reason} ->
      {stop, {create_listen_socket, Reason}}
  end.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.