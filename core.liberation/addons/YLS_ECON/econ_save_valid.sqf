// Is this a complete economy save, written by this version or an older one, with a matching checksum?
// Envelope: [version, sequence, RX save count, payload, checksum]
params [["_env", []]];

if (typeName _env != "ARRAY" || { count _env != 5 }) exitWith { false };
if (typeName (_env select 0) != "SCALAR" || { (_env select 0) < 1 } || { (_env select 0) > YLS_save_version }) exitWith { false };
if (typeName (_env select 1) != "SCALAR" || { typeName (_env select 2) != "SCALAR" }) exitWith { false };
if (typeName (_env select 3) != "ARRAY" || { count (_env select 3) != 2 }) exitWith { false };
if (typeName (_env select 4) != "STRING") exitWith { false };

(hashValue (_env select [0, 4])) == (_env select 4)
