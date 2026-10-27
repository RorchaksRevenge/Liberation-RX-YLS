// Forget the saved economy (server only): used when RX itself wipes its save, so the two never disagree.
if (!isServer) exitWith {};

private _base = [] call YLS_fnc_econSaveKey;
profileNamespace setVariable [_base, nil];
profileNamespace setVariable [_base + "_PREV", nil];
YLS_save_seq = 0;
YLS_save_blocked = nil;
diag_log format ["--- YLS Save: economy save %1 erased", _base];
