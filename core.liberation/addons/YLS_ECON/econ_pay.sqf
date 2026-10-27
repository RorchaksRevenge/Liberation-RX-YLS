// Pay from the stockpile (server only). All or nothing: if any of the three is short, nothing is taken.
// [[supplies, ammo, fuel], "reason"] call YLS_fnc_econPay  ->  true if paid, false if refused
if (!isServer) exitWith { false };
params [["_cost", [], [[]]], ["_reason", "", [""]]];

if (count _cost != 3 || { _cost findIf { typeName _x != "SCALAR" || { _x < 0 } } != -1 }) exitWith {
	diag_log format ["--- YLS Econ Error: pay: bad cost %1 (%2)", _cost, _reason];
	false
};

private _paid = false;
private _balance = [];
isNil {
	private _enough = true;
	{
		if ((YLS_stockpile get _x) < (_cost select _forEachIndex)) exitWith { _enough = false };
	} forEach YLS_econ_types;

	if (_enough) then {
		{
			YLS_stockpile set [_x, (YLS_stockpile get _x) - (_cost select _forEachIndex)];
		} forEach YLS_econ_types;
		publicVariable "YLS_stockpile";
		_paid = true;
	};
	_balance = YLS_econ_types apply { YLS_stockpile get _x };
};

if (_paid) then {
	diag_log format ["--- YLS Econ: pay %1 ok -> %2 (%3)", _cost, _balance, _reason];
} else {
	diag_log format ["--- YLS Econ: pay %1 REFUSED, have %2 (%3)", _cost, _balance, _reason];
};
_paid
