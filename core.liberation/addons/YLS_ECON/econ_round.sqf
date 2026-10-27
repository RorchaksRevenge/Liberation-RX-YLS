// Round every number in a value (nested arrays too) to _dp decimals. Saved numbers must survive the profile's text
// form unchanged, so the save keeps them to a precision the profile can store exactly.
params ["_v", ["_dp", 1]];

if (typeName _v == "ARRAY") exitWith { _v apply { [_x, _dp] call YLS_fnc_econRound } };
if (typeName _v == "SCALAR") exitWith {
	private _k = 10 ^ _dp;
	private _r = (round (_v * _k)) / _k;
	if (_r == 0) then { 0 } else { _r }
};
_v
