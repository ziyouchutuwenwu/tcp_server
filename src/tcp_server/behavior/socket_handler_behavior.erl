-module(socket_handler_behavior).

-callback on_client_connected(Socket :: port(), IP :: atom(), Port :: integer()) ->
    noreplay.

-callback on_client_data(Socket :: port(), Cmd :: integer(), InfoBin :: any()) ->
    noreplay.

-callback on_disconnected(IP :: atom(),  Port :: integer()) ->
    noreplay.