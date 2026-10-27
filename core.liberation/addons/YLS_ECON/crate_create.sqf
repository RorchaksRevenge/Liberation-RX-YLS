// Make a resource crate (server only). Returns the crate, or objNull on bad input.
// ["supplies", 100, _pos] call YLS_fnc_crateCreate
if (!isServer) exitWith { objNull };
params [["_type", ""], ["_value", 0], ["_pos", [0, 0, 0]]];

private _idx = if (typeName _type == "STRING") then { YLS_econ_types find _type } else { -1 };
if (_idx < 0) exitWith {
	diag_log format ["--- YLS Econ Error: crate: unknown type %1", _type];
	objNull
};
if (typeName _value != "SCALAR" || { _value <= 0 }) exitWith {
	diag_log format ["--- YLS Econ Error: crate: bad value %1 for %2", _value, _type];
	objNull
};

private _crate = createVehicle [YLS_crate_class select _idx, _pos, [], 0, "CAN_COLLIDE"];
_crate setMass YLS_crate_mass;
_crate setVariable ["YLS_crate_value", _value, true];
clearWeaponCargoGlobal _crate;
clearMagazineCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;
_crate
