// Read the stockpile. No argument: [supplies, ammo, fuel]. With a type: that number, or -1 if the type is unknown.
params [["_type", "", [""]]];

if (_type == "") exitWith { YLS_econ_types apply { YLS_stockpile get _x } };
if !(_type in YLS_econ_types) exitWith { -1 };
YLS_stockpile get _type
