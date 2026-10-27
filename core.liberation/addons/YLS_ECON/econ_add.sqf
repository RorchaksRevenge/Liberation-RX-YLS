// Add to one FOB's stockpile (server only). Returns the new balance of that type, or -1 on bad input.
// [getPos _fob, "supplies", 100, "crate delivered"] call YLS_fnc_econAdd
if (!isServer) exitWith { -1 };
params [["_fob", []], ["_type", ""], ["_amount", 0], ["_reason", ""]];

private _key = [_fob] call YLS_fnc_econKey;
if (_key == "" || { !(_key in YLS_stockpile) }) exitWith {
	diag_log format ["--- YLS Econ Error: add: FOB %1 is not registered (%2)", _fob, _reason];
	-1
};

private _idx = if (typeName _type == "STRING") then { YLS_econ_types find _type } else { -1 };
if (_idx < 0) exitWith {
	diag_log format ["--- YLS Econ Error: add: unknown type %1 (%2)", _type, _reason];
	-1
};

if (typeName _amount != "SCALAR" || { _amount <= 0 }) exitWith {
	diag_log format ["--- YLS Econ Error: add: bad amount %1 for %2 (%3)", _amount, _type, _reason];
	-1
};

private _balance = -1;
isNil {
	private _have = +(YLS_stockpile get _key);
	_balance = (_have select _idx) + _amount;
	_have set [_idx, _balance];
	YLS_stockpile set [_key, _have];
	publicVariable "YLS_stockpile";
};

diag_log format ["--- YLS Econ: FOB %1 add %2 +%3 -> %4 (%5)", _key, _type, _amount, _balance, _reason];
_balance
