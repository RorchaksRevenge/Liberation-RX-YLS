// After RX has written the profile: check the saved economy and log one line. Returns true if it is good.
// This reads the copy in memory, and also checks that the data still matches its checksum after a trip through
// text, which is how the profile stores it. Whether it reached the disk is for the restart script to check.
if (!isServer) exitWith { false };
if (!isNil "YLS_save_blocked") exitWith { false };

private _base = [] call YLS_fnc_econSaveKey;
private _env = profileNamespace getVariable [_base, []];
private _ok = [_env] call YLS_fnc_econSaveValid && { (_env select 1) == (missionNamespace getVariable ["YLS_save_seq", -1]) };

if (!_ok) exitWith {
	diag_log format ["--- YLS Save FAILED CHECK: expected sequence %1, key %2", missionNamespace getVariable ["YLS_save_seq", -1], _base];
	false
};

private _text = [parseSimpleArray (str _env)] call YLS_fnc_econSaveValid;
private _nStor = 0;
private _nCr = 0;
{
	{
		_nStor = _nStor + 1;
		_nCr = _nCr + count (_x select 3);
	} forEach (_x select 2);
} forEach ((_env select 3) select 0);

diag_log format [
	"--- YLS Save %1 seq=%2 fobs=%3 storages=%4 crates=%5 loose=%6 textcheck=%7 hash=%8",
	if (_text) then { "OK" } else { "WARNING" },
	_env select 1, count ((_env select 3) select 0), _nStor, _nCr, count ((_env select 3) select 1), _text, _env select 4
];
_text
