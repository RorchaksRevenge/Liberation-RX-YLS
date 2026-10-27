// Pay from one FOB's stockpile (server only). All or nothing: if any of the three is short, nothing is taken.
// [getPos _fob, [supplies, ammo, fuel], "reason"] call YLS_fnc_econPay  ->  true if paid, false if refused
if (!isServer) exitWith { false };
params [["_fob", []], ["_cost", []], ["_reason", ""]];

private _key = [_fob] call YLS_fnc_econKey;
if (_key == "" || { !(_key in YLS_stockpile) }) exitWith {
	diag_log format ["--- YLS Econ Error: pay: FOB %1 is not registered (%2)", _fob, _reason];
	false
};

if (typeName _cost != "ARRAY" || { count _cost != 3 } || { _cost findIf { typeName _x != "SCALAR" || { _x < 0 } } != -1 }) exitWith {
	diag_log format ["--- YLS Econ Error: pay: bad cost %1 (%2)", _cost, _reason];
	false
};

private _paid = false;
private _balance = [];
isNil {
	private _have = +(YLS_stockpile get _key);
	if ((_have select 0) >= (_cost select 0) && { (_have select 1) >= (_cost select 1) } && { (_have select 2) >= (_cost select 2) }) then {
		_have = [(_have select 0) - (_cost select 0), (_have select 1) - (_cost select 1), (_have select 2) - (_cost select 2)];
		YLS_stockpile set [_key, _have];
		publicVariable "YLS_stockpile";
		_paid = true;
	};
	_balance = +_have;
};

if (_paid) then {
	diag_log format ["--- YLS Econ: FOB %1 pay %2 ok -> %3 (%4)", _key, _cost, _balance, _reason];
} else {
	diag_log format ["--- YLS Econ: FOB %1 pay %2 REFUSED, have %3 (%4)", _key, _cost, _balance, _reason];
};
_paid
