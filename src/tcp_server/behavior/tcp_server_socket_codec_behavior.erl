-module(tcp_server_socket_codec_behavior).

-callback encode(DataBytes :: any()) ->
  DataBytes :: any().

-callback decode(DataBytes :: any()) ->
  DataBytes :: any().