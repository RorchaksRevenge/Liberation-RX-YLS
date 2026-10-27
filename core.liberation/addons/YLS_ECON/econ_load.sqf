// Restore the economy from the profile (server only), right after RX has loaded its own save.
// Returns 1 if a save was restored, 0 if there was nothing to restore, -1 if a save exists but none could be used.
// Never starts from an empty economy without saying so, and never lets the next save overwrite data it could not read.
if (!isServer) exitWith { -1 };

private _base = [] call YLS_fnc_econSaveKey;
private _rx = missionNamespace getVariable ["stats_saves_performed", -1];

// every FOB RX knows about gets an (empty) stockpile entry first
{ [_x] call YLS_fnc_econRegister } forEach (missionNamespace getVariable ["GRLIB_all_fobs", []]);

private _chosen = [];
private _from = "";
private _stale = [];
private _staleFrom = "";
private _anyData = false;
{
	_x params ["_label", "_env"];
	if (typeName _env == "ARRAY" && { count _env > 0 }) then {
		_anyData = true;
		if ([_env] call YLS_fnc_econSaveValid) then {
			if (_rx < 0 || { (_env select 2) == _rx }) then {
				if (_chosen isEqualTo []) then { _chosen = _env; _from = _label };
			} else {
				diag_log format ["--- YLS Load WARNING: %1 save #%2 was made with RX save count %3, RX loaded count %4", _label, _env select 1, _env select 2, _rx];
				if (_stale isEqualTo []) then { _stale = _env; _staleFrom = _label };
			};
		} else {
			diag_log format ["--- YLS Load ERROR: %1 save failed its check, kept as %2_BAD", _label, _base];
			profileNamespace setVariable [_base + "_BAD", _env];
		};
	};
} forEach [["current", profileNamespace getVariable [_base, []]], ["previous", profileNamespace getVariable [_base + "_PREV", []]]];

if (_chosen isEqualTo [] && { !(_stale isEqualTo []) }) then {
	_chosen = _stale;
	_from = _staleFrom + ", RX save count differs";
	diag_log "--- YLS Load WARNING: using the newest valid economy save although its RX save count differs";
};

if (_chosen isEqualTo []) exitWith {
	if (_anyData) then {
		YLS_save_blocked = true;
		diag_log format ["--- YLS Load ERROR: an economy save exists but none is usable. Starting with an EMPTY economy. Saving is BLOCKED so the old data is not overwritten (see %1_BAD). To allow saving again: YLS_save_blocked = nil", _base];
		-1
	} else {
		diag_log "--- YLS Load: no economy save, starting empty";
		0
	};
};

private _payload = _chosen select 3;
private _nStor = 0;
private _nCr = 0;
private _nLoose = 0;
private _skipped = 0;

{
	_x params ["_key", "_pos", "_storages", "_totals"];
	[_pos] call YLS_fnc_econRegister;
	{
		_x params ["_class", "_posW", "_dirUp", "_crates"];
		if (_class == YLS_storage_class) then {
			private _st = createVehicle [_class, [0, 0, 0], [], 0, "CAN_COLLIDE"];
			_st setVectorDirAndUp _dirUp;
			_st setPosWorld _posW;
			_nStor = _nStor + 1;
			{
				_x params ["_type", "_value"];
				private _crate = [_type, _value, _posW vectorAdd [0, 0, 3]] call YLS_fnc_crateCreate;
				if (isNull _crate) then {
					_skipped = _skipped + 1;
				} else {
					if (([_crate, _st] call YLS_fnc_storeAttach) < 0) then {
						[_crate] call YLS_fnc_crateRemove;
						_skipped = _skipped + 1;
						diag_log format ["--- YLS Load WARNING: storage at %1 is full, a %2 crate was dropped", _posW, _type];
					} else {
						_nCr = _nCr + 1;
					};
				};
			} forEach _crates;
		} else {
			diag_log format ["--- YLS Load WARNING: unknown storage class %1 skipped", _class];
			_skipped = _skipped + 1;
		};
	} forEach _storages;

	private _have = [[_pos] call YLS_fnc_storeRecalc, 2] call YLS_fnc_econRound;
	if !(_have isEqualTo _totals) then {
		diag_log format ["--- YLS Load WARNING: FOB %1 restored %2 but the save said %3", _key, _have, _totals];
	};
} forEach (_payload select 0);

{
	_x params ["_type", "_value", "_posW", "_dirUp"];
	private _crate = [_type, _value, _posW] call YLS_fnc_crateCreate;
	if (isNull _crate) then {
		_skipped = _skipped + 1;
	} else {
		_crate setVectorDirAndUp _dirUp;
		_crate setPosWorld _posW;
		_nLoose = _nLoose + 1;
	};
} forEach (_payload select 1);

YLS_save_seq = _chosen select 1;
diag_log format ["--- YLS Load OK seq=%1 from=%2 fobs=%3 storages=%4 crates=%5 loose=%6 skipped=%7", _chosen select 1, _from, count (_payload select 0), _nStor, _nCr, _nLoose, _skipped];
1
