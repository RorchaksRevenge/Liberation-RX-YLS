// The live crates in one storage, in slot order. Destroyed, deleted and used-up crates (value 0) are dropped.
// Returns a copy.
params [["_storage", objNull]];

private _list = (_storage getVariable ["YLS_crates", []]) select {
	!isNull _x && { alive _x } && { (_x getVariable ["YLS_crate_value", 0]) > 0 }
};
_storage setVariable ["YLS_crates", _list];
+_list
