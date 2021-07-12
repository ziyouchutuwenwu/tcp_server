-module(on_app_start).

main(_Args) ->
  io:format("~n"),
  interprete_modules(),
  io:format("try tcp_server_demo:start().~n").

interprete_modules() ->
  int:ni(utf8_list),
  int:ni(data_format),
  int:ni(crypt),
  int:ni(safe_atom),
  int:ni(data_convert),
  int:ni(random_generator),
  int:ni(demo_server_socket_codec_impl),
  int:ni(tcp_server_listener),
  int:ni(tcp_server_send),
  int:ni(tcp_server_app),
  int:ni(tcp_server),
  int:ni(demo_server_socket_config_behavior_impl),
  int:ni(demo_server_socket_handler_impl),
  int:ni(tcp_server_sup),
  int:ni(tcp_server_handler_sup),
  int:ni(tcp_server_socket_handler_behavior),
  int:ni(tcp_server_listener_sup),
  int:ni(demo_server_options_impl),
  int:ni(tcp_server_options_behavior),
  int:ni(demo_server_socket_package_impl),
  int:ni(tcp_server_socket_codec_behavior),
  int:ni(tcp_server_demo),
  int:ni(tcp_server_socket_package_behavior),
  int:ni(tcp_server_handler),

  io:format("输入 int:interpreted(). 或者 il(). 查看模块列表~n").