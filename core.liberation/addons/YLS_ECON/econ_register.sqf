// Give a FOB its (empty) stockpile entry (server only). Safe to call again: an existing entry is left alone.
// Returns the FOB key, or "" if the position is not usable.
if (!isServer) exitWith { "" };
params [["_fob", []]];

private _key = [_fob] call YLS_fnc_econKey;
if (_key == "") exitWith {
	diag_log format ["--- YLS Econ Error: register: bad FOB position %1", _fob];
	""
};

isNil {
	if !(_key in YLS_stockpile) then {
		YLS_stockpile set [_key, [0, 0, 0]];
		publicVariable "YLS_stockpile";
		diag_log format ["--- YLS Econ: FOB %1 registered", _key];
	};
};
_key
