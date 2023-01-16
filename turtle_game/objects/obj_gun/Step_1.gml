if (global.game_pause) exit;

x = obj_player.x - 10;
y = obj_player.y - 10;

image_angle = point_direction(x, y, mouse_x, mouse_y);

firing_delay -= 1;
recoil = max(0, recoil - 1);

if (mouse_check_button(mb_left) and firing_delay < 0 and ammo > 0) {
	
	// check if currently inputting thing into interval
	var can_shoot = true;
	
	with (obj_interval) {
		if (within_bounds) can_shoot = false;
	}
	
	if (can_shoot) {
		//shoots every 5 frames
		firing_delay = 5;
		recoil = 4;
	
		if (reduce_ammo) ammo -= 1;
	
		with (instance_create_layer(x, y, "Bullets", obj_bullet)) {
			speed = 25;
			direction = other.image_angle + random_range(-3, 3);
			image_angle = direction;
		}
	
		with (obj_player) {
			gunkick_x = lengthdir_x(1.5, other.image_angle-180);
			gunkick_y = lengthdir_y(1, other.image_angle-180);
		}
	}
}

if (recoil > 0) {
	x -= lengthdir_x(recoil, image_angle);
	y -= lengthdir_y(recoil, image_angle);
}

if (image_angle > 90 and image_angle < 270) image_yscale = -1;
else image_yscale = 1;