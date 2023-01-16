timer = 0;

timer_spawn_enemy = 15; // in seconds
timer_kill_stuck = 60;

if (obj_game.lower_difficulty) timer_spawn_enemy = 30;

spawn_xarray = [244, 1286, 850, 128, 1400];
spawn_yarray = [352, 325, 160, 1344, 69];

function spawn_a_few(_x, _y, num_enemy1, num_enemy2) {
	
	repeat (num_enemy1) {
		with (instance_create_layer(_x, _y, "Instances", obj_enemy1)) {
			moveX = irandom_range(-8, 8) * spd;
			moveY = -10 - irandom_range(0, 10);
		}
	}
			
	repeat (num_enemy2) {
		with (instance_create_layer(_x, _y, "Instances", obj_enemy2)) {
			moveX = irandom_range(-8, 8) * spd;
			moveY = -10 - irandom_range(0, 10);
		}
	}
	
}