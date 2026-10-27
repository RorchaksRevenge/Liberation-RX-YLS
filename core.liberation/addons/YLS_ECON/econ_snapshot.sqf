// Everything the save needs, as plain data: [fobs, loose crates].
//   fob   = [key, position, storages, totals]
//   storage = [class, position, [dir, up], crates]      crates = [[type, value], ...] in slot order
//   loose crate = [type, value, position, [dir, up]]     (crates outside any FOB storage, e.g. on their way to one)
// Numbers are rounded so they survive the profile's text form exactly.
private _fobs = [];
private _stored = [];

{
	private _key = _x;
	if (_key in YLS_fob_pos) then {
		private _pos = YLS_fob_pos get _key;
		private _totals = [_pos] call YLS_fnc_storeRecalc;
		private _storages = [];
		{
			private _st = _x;
			private _crates = [_st] call YLS_fnc_storeCrates;
			_stored append _crates;
			_storages pushBack [
				typeOf _st,
				[getPosWorld _st, 1] call YLS_fnc_econRound,
				[[vectorDir _st, vectorUp _st], 3] call YLS_fnc_econRound,
				_crates apply {
					[YLS_econ_types select (YLS_crate_class find (typeOf _x)), [_x getVariable ["YLS_crate_value", 0], 2] call YLS_fnc_econRound]
				}
			];
		} forEach ([_pos] call YLS_fnc_storeFind);
		_fobs pushBack [_key, [_pos, 1] call YLS_fnc_econRound, _storages, [_totals, 2] call YLS_fnc_econRound];
	};
} forEach (keys YLS_stockpile);

private _loose = [];
{
	private _class = _x;
	private _t = _forEachIndex;
	{
		private _v = _x getVariable ["YLS_crate_value", 0];
		if (alive _x && { _v > 0 } && { !(_x in _stored) }) then {
			_loose pushBack [
				YLS_econ_types select _t,
				[_v, 2] call YLS_fnc_econRound,
				[getPosWorld _x, 1] call YLS_fnc_econRound,
				[[vectorDir _x, vectorUp _x], 3] call YLS_fnc_econRound
			];
		};
	} forEach (allMissionObjects _class);
} forEach YLS_crate_class;

[_fobs, _loose]
