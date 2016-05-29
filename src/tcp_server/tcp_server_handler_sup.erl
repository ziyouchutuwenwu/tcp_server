-module(tcp_server_handler_sup).
-behaviour(supervisor).

-export([start_link/3, start_child/1]).
-export([init/1]).

start_link(Name, LSock, ConfigBehavior) ->
	LocalModuleName = safe_atom:list_to_atom(Name ++ "_" ++ ?MODULE_STRING),
	supervisor:start_link({local, LocalModuleName}, ?MODULE, [Name, LSock, ConfigBehavior]).

start_child(Name) ->
	LocalModuleName = safe_atom:list_to_atom(Name ++ "_" ++ ?MODULE_STRING),
	supervisor:start_child(LocalModuleName, []).

init([Name, LSock, ConfigBehavior]) ->

	RestartMode = simple_one_for_one,
	MaxRestarts = 0,
	MaxSecondsBetweenRestarts = 1,

	RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

	Restart = temporary,
	Shutdown = brutal_kill,
	Type = worker,

	Child = {
		tcp_server_handler,
		{tcp_server_handler, start_link, [Name, LSock, ConfigBehavior]},
		Restart, Shutdown, Type,
		[tcp_server_handler]
	},

	Children = [Child],
	{ok, {RestartStrategy, Children}}.