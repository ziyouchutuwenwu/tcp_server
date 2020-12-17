-module(tcp_server).

-export([start/3, stop/1, send_socket_msg/4]).

start(Name, Port, ConfigBehavior) ->
	tcp_server_listener_sup:start_link(Name, Port, ConfigBehavior).

stop(_S) ->
	ok.

send_socket_msg(Socket, Cmd, InfoBin, ConfigBehavior) ->
	SocketPackModule = ConfigBehavior:get_socket_package_module(),
	DataBin = SocketPackModule:pack(Cmd, InfoBin),

	SocketCodecModule = ConfigBehavior:get_socket_codec_module(),
	Data = SocketCodecModule:encode(DataBin),

	gen_tcp:send(Socket, Data),
	ok.