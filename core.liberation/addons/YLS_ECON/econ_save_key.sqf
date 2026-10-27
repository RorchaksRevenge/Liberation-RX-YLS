// Profile key the economy is saved under: next to RX's own save key, one per map. A test can override it.
private _o = missionNamespace getVariable ["YLS_save_key_override", ""];
if (_o != "") exitWith { _o };

format ["YLS_ECON_%1", missionNamespace getVariable ["GRLIB_save_key", "LRX_SAVEGAME"]]
