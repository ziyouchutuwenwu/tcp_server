-module(tcp_server_test).

-compile(export_all).

start()->
	tcp_server:start("server1", 9999,my_socket_config_behavior_impl).