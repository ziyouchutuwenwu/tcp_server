-module(demo_server_socket_codec_impl).
-behaviour(tcp_server_socket_codec_behavior).

-export([encode/1, decode/1]).

encode(DataBytes) ->
  DataBytes.

decode(DataBytes) ->
  DataBytes.