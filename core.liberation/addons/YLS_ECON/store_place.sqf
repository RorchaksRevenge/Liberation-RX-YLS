// Put a crate in slot _i of a storage, resting on the slab.
params ["_crate", "_storage", "_i"];

private _slot = YLS_storage_slots select _i;
private _t = YLS_crate_class find (typeOf _crate);
private _half = if (_t < 0) then { 0.64 } else { YLS_crate_half select _t };

detach _crate;
_crate attachTo [_storage, [_slot select 0, _slot select 1, YLS_storage_top + _half]];
_crate setVectorDirAndUp [[0, 1, 0], [0, 0, 1]];
