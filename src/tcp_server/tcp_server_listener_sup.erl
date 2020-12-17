-module(tcp_server_listener_sup).

-behaviour(supervisor).

-export([start_link/3]).
-export([init/1]).

start_link(Name, Port, ConfigBehavior) ->
  LocalModuleName = safe_atom:list_to_atom(Name ++ "_" ++ ?MODULE_STRING),
  supervisor:start_link({local, LocalModuleName}, ?MODULE, [Name, Port, ConfigBehavior]).

init([Name, Port, ConfigBehavior]) ->

  RestartMode = one_for_one,
  MaxRestarts = 10,
  MaxSecondsBetweenRestarts = 1,

  RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = transient,
  Shutdown = brutal_kill,
  Type = worker,

  Child = {
    tcp_server_listener,
    {tcp_server_listener, start_link, [Name, Port, ConfigBehavior]},
    Restart, Shutdown, Type,
    [tcp_server_listener]
  },

  Children = [Child],
  {ok, {RestartStrategy, Children}}.