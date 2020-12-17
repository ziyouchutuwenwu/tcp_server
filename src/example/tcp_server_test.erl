-module(tcp_server_test).

-compile(export_all).

start()->
	tcp_server:start("server1", 9999, my_socket_config_behavior_impl).

%% 需要的时候，手动在 on_client_connected 的实现 里面调用
send(Socket)->
	tcp_server:send_socket_msg(Socket, 111, <<"this is test info">>,  my_socket_config_behavior_impl).