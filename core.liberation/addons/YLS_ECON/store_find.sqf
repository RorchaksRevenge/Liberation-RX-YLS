// The storage containers belonging to a FOB: the YLS storage class within the FOB range of its position.
params [["_fob", []]];

if (typeName _fob != "ARRAY" || { count _fob < 2 }) exitWith { [] };
private _range = missionNamespace getVariable ["GRLIB_fob_range", 125];
(nearestObjects [_fob, [YLS_storage_class], _range]) select { alive _x }
