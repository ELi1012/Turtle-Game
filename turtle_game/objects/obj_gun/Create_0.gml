firing_delay = 0;
recoil = 0;

ammo = 50*2;
ammo_round = 50; //number of bullets in an ammo
ammo_max = ammo_round * 3;

function equip_ammo() {
	ammo = min(ammo + ammo_round, ammo_max);
}

reduce_ammo = true;