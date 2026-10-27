// Sum of every FOB's stockpile: [supplies, ammo, fuel]. For the commander and the HUD, not for spending.
private _sum = [0, 0, 0];
{
	_sum = [(_sum select 0) + (_x select 0), (_sum select 1) + (_x select 1), (_sum select 2) + (_x select 2)];
} forEach (values YLS_stockpile);
_sum
