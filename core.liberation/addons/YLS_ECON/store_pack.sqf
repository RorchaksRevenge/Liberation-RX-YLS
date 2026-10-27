// Close the gaps in a storage: every crate moves to the lowest free slot, in order. Returns the crate count.
params [["_storage", objNull]];

private _list = [_storage] call YLS_fnc_storeCrates;
{
	[_x, _storage, _forEachIndex] call YLS_fnc_storePlace;
} forEach _list;
count _list
