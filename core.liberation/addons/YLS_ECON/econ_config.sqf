// YLS economy settings. Sizes were measured in game (Arma 2.22).
YLS_econ_types = ["supplies", "ammo", "fuel"];

// One crate class per resource, in the same order as YLS_econ_types.
YLS_crate_class = ["CargoNet_01_box_F", "B_CargoNet_01_ammo_F", "CargoNet_01_barrels_F"];
YLS_crate_half = [0.64, 0.84, 0.53];	// half the crate height (m)
YLS_crate_value = 100;					// resource units in a full crate
YLS_crate_mass = 500;					// KP uses 500 so a helicopter can sling a crate

// Storage: a small sand ContainmentArea holds 12 crates in a 4 x 3 grid.
YLS_storage_class = "ContainmentArea_02_sand_F";
YLS_storage_top = 0.24;					// top of the slab above its origin (m)
YLS_storage_slots = [
	[-2.35, 1.8], [-0.75, 1.8], [0.85, 1.8], [2.45, 1.8],
	[-2.35, 0], [-0.75, 0], [0.85, 0], [2.45, 0],
	[-2.35, -1.8], [-0.75, -1.8], [0.85, -1.8], [2.45, -1.8]
];
