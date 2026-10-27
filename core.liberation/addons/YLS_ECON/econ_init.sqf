// YLS shared stockpile (server side). One pool of supplies, ammo and fuel for everyone.
if (!isServer) exitWith {};

YLS_econ_types = ["supplies", "ammo", "fuel"];
YLS_stockpile = createHashMapFromArray [["supplies", 0], ["ammo", 0], ["fuel", 0]];
publicVariable "YLS_econ_types";
publicVariable "YLS_stockpile";

YLS_fnc_econGet = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_get.sqf";
YLS_fnc_econAdd = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_add.sqf";
YLS_fnc_econPay = compileFinal preprocessFileLineNumbers "addons\YLS_ECON\econ_pay.sqf";

diag_log "--- YLS Econ: stockpile ready";
