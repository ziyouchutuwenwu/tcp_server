-module(demo_server_socket_handler_impl).

-behaviour(tcp_server_socket_handler_behavior).

-export([on_client_connected/3, on_client_data/3, on_disconnected/2]).

on_client_connected(Socket, IP, Port) ->
  io:format("客户端 ~ts:~p 连接~n", [IP, Port]),
  tcp_server_demo:send(Socket),
  noreplay.

on_client_data(_Socket, Cmd, InfoBin) ->
  io:format("收到客户端数据~p ~p~n", [Cmd, InfoBin]),
  noreplay.

on_disconnected(IP, Port) ->
  io:format("客户端 ~ts:~p 断开连接~n", [IP, Port]),
  noreplay.