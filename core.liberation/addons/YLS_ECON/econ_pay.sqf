// Pay from one FOB (server only). The cost is taken out of the crates in its storage, newest crate first, like KP:
// a crate with enough value loses that value, a used-up crate is deleted. All or nothing: if any of the three is
// short, nothing is taken.
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
	private _have = [_fob] call YLS_fnc_storeRecalc;
	if ((_have select 0) >= (_cost select 0) && { (_have select 1) >= (_cost select 1) } && { (_have select 2) >= (_cost select 2) }) then {
		private _storages = [_fob] call YLS_fnc_storeFind;
		{
			private _t = _forEachIndex;
			private _price = _cost select _t;
			{
				private _st = _x;
				private _crates = [_st] call YLS_fnc_storeCrates;
				reverse _crates;
				{
					private _c = _x;
					if (_price > 0 && { (YLS_crate_class find (typeOf _c)) == _t }) then {
						private _v = _c getVariable ["YLS_crate_value", 0];
						if (_v > _price) then {
							_c setVariable ["YLS_crate_value", _v - _price, true];
							_price = 0;
						} else {
							_price = _price - _v;
							[_c] call YLS_fnc_crateRemove;
						};
					};
				} forEach _crates;
			} forEach _storages;
		} forEach YLS_econ_types;

		{ [_x] call YLS_fnc_storePack } forEach _storages;
		_paid = true;
	};
	_balance = [_fob] call YLS_fnc_storeRecalc;
};

if (_paid) then {
	diag_log format ["--- YLS Econ: FOB %1 pay %2 ok -> %3 (%4)", _key, _cost, _balance, _reason];
} else {
	diag_log format ["--- YLS Econ: FOB %1 pay %2 REFUSED, have %3 (%4)", _key, _cost, _balance, _reason];
};
_paid
