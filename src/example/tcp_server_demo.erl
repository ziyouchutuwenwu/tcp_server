-module(tcp_server_demo).

%% -compile(export_all).
-export([start/0, send_by_socket/1, send_by_pid/1]).

start() ->
  tcp_server:start("server1", 9999, demo_server_socket_config_behavior_impl).

%% 需要的时候，手动调用
send_by_socket(Socket) ->
  tcp_server_send:send_data_by_socket(Socket, 111, <<"msg send by socket">>, demo_server_socket_config_behavior_impl).

send_by_pid(Pid) ->
  tcp_server_send:send_data_by_pid(Pid, 111, <<"msg send by pid">>).