// Remove a crate from the world (server only). Its value is zeroed first: a deleted object still counts as alive
// until the end of the frame, and a second purchase in the same frame must not be able to spend it again.
params [["_crate", objNull]];

if (isNull _crate) exitWith {};
_crate setVariable ["YLS_crate_value", 0, true];
detach _crate;
deleteVehicle _crate;
