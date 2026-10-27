// Put a crate in the next free slot of a storage (server only). Returns the slot index, or -1 if the storage is full.
if (!isServer) exitWith { -1 };
params [["_crate", objNull], ["_storage", objNull]];

if (isNull _crate || { isNull _storage }) exitWith { -1 };

private _list = [_storage] call YLS_fnc_storeCrates;
if (count _list >= count YLS_storage_slots) exitWith { -1 };

private _i = count _list;
[_crate, _storage, _i] call YLS_fnc_storePlace;
_list pushBack _crate;
_storage setVariable ["YLS_crates", _list];

// a stored crate cannot be sling-lifted
[_crate, false] remoteExec ["enableRopeAttach"];
_i
