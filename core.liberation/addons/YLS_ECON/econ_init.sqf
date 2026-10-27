// YLS stockpile (server side). Each FOB has its own supplies, ammo and fuel, like KP Liberation.
// YLS_stockpile is a map: FOB key -> [supplies, ammo, fuel]. The key comes from the FOB position.
if (!isServer) exitWith {};

YLS_econ_types = ["supplies", "ammo", "fuel"];
YLS_stockpile = createHashMap;
publicVariable "YLS_econ_types";
publicVariable "YLS_stockpile";

YLS_fnc_econKey = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_key.sqf";
YLS_fnc_econRegister = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_register.sqf";
YLS_fnc_econGet = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_get.sqf";
YLS_fnc_econAdd = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_add.sqf";
YLS_fnc_econPay = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_pay.sqf";
YLS_fnc_econTotal = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_total.sqf";

diag_log "--- YLS Econ: stockpile ready";
