// Set a FOB's stockpile to the sum of the crate values in its storage. Returns [supplies, ammo, fuel],
// or [] if the FOB is not registered.
params [["_fob", []]];

private _key = [_fob] call YLS_fnc_econKey;
if (_key == "" || { !(_key in YLS_stockpile) }) exitWith { [] };

private _sum = [0, 0, 0];
{
	{
		private _t = YLS_crate_class find (typeOf _x);
		if (_t >= 0) then {
			_sum set [_t, (_sum select _t) + (_x getVariable ["YLS_crate_value", 0])];
		};
	} forEach ([_x] call YLS_fnc_storeCrates);
} forEach ([_fob] call YLS_fnc_storeFind);

YLS_stockpile set [_key, _sum];
publicVariable "YLS_stockpile";
_sum
