// Stockpile key for a FOB position: x and y rounded to whole metres, "" if the position is not usable.
// [getPos _fob] call YLS_fnc_econKey  ->  "1000_1000"
params [["_fob", []]];

if (typeName _fob != "ARRAY" || { count _fob < 2 }) exitWith { "" };
if (typeName (_fob select 0) != "SCALAR" || { typeName (_fob select 1) != "SCALAR" }) exitWith { "" };

format ["%1_%2", round (_fob select 0), round (_fob select 1)]
