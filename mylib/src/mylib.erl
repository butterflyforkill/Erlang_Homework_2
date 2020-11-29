-module(mylib).

-export([create/1,insert/3,lookup/1,delete_obsolete/0]).

create(TableName) ->
    try ets:new(cache,TableName) of
	cache -> ok
    catch
	error:badarg ->
	    {error, already_created}
    end.

insert(Key,Value,TimeToLive) ->
    ExpTime = TimeToLive + current_time(),
    try ets:insert(cache,{Key,Value,ExpTime}) of
	true -> ok
    catch
	error:badarg ->
	    {error,no_exist}
    end.

lookup(Key) ->
    Now = current_time(),
    try ets:select(cache, [{{'$1','$2','$3'},[{'>','$3',Now},{'=:=','$1',Key}],['$$']}])
    of
	[Value] -> {ok, Value};
	[] -> {error, undefined}
    catch
	error:badarg ->
	    {error,not_exist}
    end.
	     
delete_obsolete() ->
    Now = current_time(),
    try
	ets:select_delete(cache,[{{'$_','$_','$3'},[{'=<','$3',Now}],['$$']}])
    of
	_ -> ok
    catch
		error:badarg -> {error, not_exists}
    end.

current_time() ->
	calendar:datetime_to_gregorian_seconds(calendar:local_time()).
