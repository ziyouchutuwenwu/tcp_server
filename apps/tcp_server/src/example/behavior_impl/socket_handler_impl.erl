-module(socket_handler_impl).

-behaviour(socket_handler_behavior).

-export([on_client_connected/3, on_client_data/3, on_disconnected/2]).

on_client_connected(_Socket, IP, Port) ->
    io:format("客户端~p:~p连接成功~n",[IP, Port]),
    noreplay.

on_client_data(_Socket, Cmd, InfoBin) ->
    io:format("收到客户端数据~p ~p~n",[Cmd, InfoBin]),
    noreplay.

on_disconnected(IP, Port) ->
    io:format("客户端~p:~p断开连接~n",[IP, Port]),
    noreplay.