-module(tcp_server).

-export([start/3, stop/1]).

start(Name, Port, ConfigBehavior) ->
	tcp_server_listener_sup:start_link(Name, Port, ConfigBehavior).

stop(_S) ->
	ok.