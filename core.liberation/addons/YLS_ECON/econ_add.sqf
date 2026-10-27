// Add resources to a FOB (server only): crates of up to YLS_crate_value appear in its storage.
// Returns the FOB's new balance of that type, or -1 if refused (bad input, no storage, or not enough free slots).
// [getPos _fob, "supplies", 250, "production"] call YLS_fnc_econAdd
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

private _storages = [_fob] call YLS_fnc_storeFind;
if (_storages isEqualTo []) exitWith {
	diag_log format ["--- YLS Econ: FOB %1 add %2 +%3 REFUSED, no storage (%4)", _key, _type, _amount, _reason];
	-1
};

private _balance = -1;
isNil {
	private _free = 0;
	{ _free = _free + (count YLS_storage_slots) - (count ([_x] call YLS_fnc_storeCrates)) } forEach _storages;

	if (_free >= ceil (_amount / YLS_crate_value)) then {
		private _left = _amount;
		{
			private _st = _x;
			while { _left > 0 && { count ([_st] call YLS_fnc_storeCrates) < count YLS_storage_slots } } do {
				private _v = _left min YLS_crate_value;
				private _crate = [_type, _v, (getPosATL _st) vectorAdd [0, 0, 2]] call YLS_fnc_crateCreate;
				[_crate, _st] call YLS_fnc_storeAttach;
				_left = _left - _v;
			};
		} forEach _storages;
		_balance = ([_fob] call YLS_fnc_storeRecalc) select _idx;
	};
};

if (_balance < 0) then {
	diag_log format ["--- YLS Econ: FOB %1 add %2 +%3 REFUSED, storage full (%4)", _key, _type, _amount, _reason];
} else {
	diag_log format ["--- YLS Econ: FOB %1 add %2 +%3 -> %4 (%5)", _key, _type, _amount, _balance, _reason];
};
_balance
