-module(socket_handler_impl).

-behaviour(socket_handler_behavior).

-export([on_client_connected/1, on_client_data/2, on_disconnected/1]).

on_client_connected(IP) ->
    io:format("客户端~p连接~n",[IP]),
    noreplay.

on_client_data(Cmd, InfoBin) ->
    io:format("收到客户端数据~p ~p~n",[Cmd, InfoBin]),
    noreplay.

on_disconnected(IP) ->
    io:format("客户端~p断开连接~n",[IP]),
    noreplay.