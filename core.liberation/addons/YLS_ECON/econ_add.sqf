// Add to the stockpile (server only). Returns the new balance of that type, or -1 on bad input.
// ["supplies", 100, "crate delivered"] call YLS_fnc_econAdd
if (!isServer) exitWith { -1 };
params [["_type", "", [""]], ["_amount", 0, [0]], ["_reason", "", [""]]];

if !(_type in YLS_econ_types) exitWith {
	diag_log format ["--- YLS Econ Error: add: unknown type '%1'", _type];
	-1
};
if (_amount <= 0) exitWith {
	diag_log format ["--- YLS Econ Error: add: bad amount %1 for %2", _amount, _type];
	-1
};

private _balance = -1;
isNil {
	_balance = (YLS_stockpile get _type) + _amount;
	YLS_stockpile set [_type, _balance];
	publicVariable "YLS_stockpile";
};

diag_log format ["--- YLS Econ: add %1 +%2 -> %3 (%4)", _type, _amount, _balance, _reason];
_balance
