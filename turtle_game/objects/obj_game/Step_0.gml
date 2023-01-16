if (keyboard_check_pressed(vk_f8)) game_end();
if (keyboard_check_pressed(vk_f1)) game_restart();
//if (keyboard_check_pressed(vk_f2)) debugging = !debugging;

// debugging cheats
// make interval

// ONLY RUN IF IN MAIN ROOM
/*
if (mouse_check_button_pressed(mb_left) and place_meeting(mouse_x, mouse_y, obj_ingrbox)) {
	var inst = instance_place(mouse_x, mouse_y, obj_ingrbox);
	with (obj_interval) instance_destroy();
	
	var ii = obj_game.create_interval(inst.x, inst.y - 30);
	inst.interval_id = ii;
	ii.ingrbox_id = inst;
}

if (mouse_check_button_pressed(mb_left)) {
	// create ingr
	if (keyboard_check(vk_control)) {
		with (instance_create_layer(mouse_x, mouse_y, "Instances", obj_ingr)) ingredient = irandom_range(0, 5);
	} else if (keyboard_check(ord("Q"))) {
		// create knifer
		instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy1);
	} else if (keyboard_check(vk_shift)) {
		// create stealer
		instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy2);
	}
}
*/