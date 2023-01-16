if (global.game_pause) exit;


timer += 1;
var seconds = timer/room_speed;

if (seconds mod timer_spawn_enemy == 0) {
	var j = choose(1, 2, 3);
	var location = irandom_range(0, array_length(spawn_xarray)-1);
	var xx = spawn_xarray[location];
	var yy = spawn_yarray[location];
	
	if (j == 1) {
		// spawn enemy 1
		instance_create_layer(xx, yy, "Instances", obj_enemy1);
		
		
	} else {
		// spawn enemy 2
		instance_create_layer(xx, yy, "Instances", obj_enemy2);
		
	}
	
}

// put things out of their misery
if (seconds >= timer_kill_stuck) {
	timer = 0;
	with (par_enemy) {
		if (place_meeting(x, y, obj_collision)) instance_destroy();
	}
}