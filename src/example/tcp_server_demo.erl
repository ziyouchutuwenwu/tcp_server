-module(tcp_server_demo).

-compile(export_all).

start() ->
  tcp_server:start("server1", 9999, demo_server_socket_config_behavior_impl).

%% 需要的时候，手动在 on_client_connected 的实现 里面调用
send(Socket) ->
  tcp_server:send_socket_msg(Socket, 111, <<"hello from server">>, demo_server_socket_config_behavior_impl).