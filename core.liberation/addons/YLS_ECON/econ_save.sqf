// Put the economy into the profile (server only). RX writes the profile to disk right after this, in the same
// save, so both are written together. The previous good save is kept under the _PREV key.
// Returns true if a new save was set, false if saving is blocked.
if (!isServer) exitWith { false };

if (!isNil "YLS_save_blocked") exitWith {
	diag_log "--- YLS Save SKIPPED: a load found unusable economy data and saving is blocked so it is not overwritten (YLS_save_blocked = nil to allow)";
	false
};

private _base = [] call YLS_fnc_econSaveKey;
private _seq = (missionNamespace getVariable ["YLS_save_seq", 0]) + 1;
private _body = [
	YLS_save_version,
	_seq,
	missionNamespace getVariable ["stats_saves_performed", -1],
	[] call YLS_fnc_econSnapshot
];
private _env = _body + [hashValue _body];

// the current save becomes the previous one, but only if it is itself good
private _cur = profileNamespace getVariable [_base, []];
if ([_cur] call YLS_fnc_econSaveValid) then {
	profileNamespace setVariable [_base + "_PREV", _cur];
} else {
	if (typeName _cur == "ARRAY" && { count _cur > 0 }) then {
		diag_log format ["--- YLS Save WARNING: the current save was not valid, kept as %1_BAD", _base];
		profileNamespace setVariable [_base + "_BAD", _cur];
	};
};

profileNamespace setVariable [_base, _env];
YLS_save_seq = _seq;
true
