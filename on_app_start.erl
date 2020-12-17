-module(on_app_start).

-export([main/1]).

main(Args) ->
  io:format("~n"),
  io:format("try tcp_server_demo:start().~n"),
  io:format("~n").