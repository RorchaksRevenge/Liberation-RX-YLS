// YLS stockpile (server side). Each FOB has its own supplies, ammo and fuel, like KP Liberation.
// The resources are physical crates in the FOB's storage. YLS_stockpile is a map: FOB key -> [supplies, ammo, fuel],
// always recalculated from the crates.
if (!isServer) exitWith {};

[] call compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_config.sqf";

YLS_stockpile = createHashMap;
YLS_fob_pos = createHashMap;		// FOB key -> the position it was registered with (the save needs it)
YLS_save_seq = 0;
publicVariable "YLS_econ_types";
publicVariable "YLS_stockpile";

YLS_fnc_econKey = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_key.sqf";
YLS_fnc_econRegister = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_register.sqf";
YLS_fnc_econGet = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_get.sqf";
YLS_fnc_econAdd = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_add.sqf";
YLS_fnc_econPay = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_pay.sqf";
YLS_fnc_econTotal = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_total.sqf";

YLS_fnc_crateCreate = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\crate_create.sqf";
YLS_fnc_crateRemove = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\crate_remove.sqf";
YLS_fnc_storeFind =compileFinal preprocessFileLineNumbers "addons\YLS_ECON\store_find.sqf";
YLS_fnc_storeCrates = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\store_crates.sqf";
YLS_fnc_storePlace = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\store_place.sqf";
YLS_fnc_storeAttach = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\store_attach.sqf";
YLS_fnc_storePack = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\store_pack.sqf";
YLS_fnc_storeRecalc = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\store_recalc.sqf";

YLS_fnc_econRound = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_round.sqf";
YLS_fnc_econSaveKey = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_save_key.sqf";
YLS_fnc_econSnapshot = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_snapshot.sqf";
YLS_fnc_econSaveValid = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_save_valid.sqf";
YLS_fnc_econSave = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_save.sqf";
YLS_fnc_econSaveCheck = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_save_check.sqf";
YLS_fnc_econLoad = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_load.sqf";
YLS_fnc_econWipe = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_wipe.sqf";

diag_log "--- YLS Econ: stockpile ready";
