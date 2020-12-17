-module(demo_server_socket_config_behavior_impl).

-export([get_socket_handler_module/0, get_socket_codec_module/0, get_socket_package_module/0, get_socket_options_module/0]).

get_socket_handler_module() ->
  demo_server_socket_handler_impl.

get_socket_codec_module() ->
  demo_server_socket_codec_impl.

%% 业务级别拆包
get_socket_package_module() ->
  demo_server_socket_package_impl.

get_socket_options_module() ->
  demo_server_options_impl.