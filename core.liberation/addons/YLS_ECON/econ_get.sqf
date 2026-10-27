// Read one FOB's stockpile. No type: [supplies, ammo, fuel]. With a type: that number.
// An unregistered FOB gives [] (no type) or -1. An unknown type gives -1.
params [["_fob", []], ["_type", ""]];

private _key = [_fob] call YLS_fnc_econKey;
if (_key == "" || { !(_key in YLS_stockpile) }) exitWith { if (_type == "") then { [] } else { -1 } };

private _have = YLS_stockpile get _key;
if (_type == "") exitWith { +_have };

private _idx = YLS_econ_types find _type;
if (_idx < 0) exitWith { -1 };
_have select _idx
