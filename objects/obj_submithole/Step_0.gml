if (global.game_pause) exit;


// timer
if (timer/room_speed >= bread_deadline) {
	timer = 0;
	
	
	// spawn guys
	obj_enemy_spawner.spawn_a_few(x, y, 3, 3);
	screen_shake(20, 10);
	
}

timer += 1;







if (place_meeting(x, y, obj_dough)) { //(keyboard_check_pressed(interact_key) and place_meeting(x, y, obj_player)) {
	var inst = instance_place(x, y, obj_dough); //obj_player.current_item;
	
	// if item is equiped and item is dough
	if (inst.vspd >= 0 and inst.dropmove) {  //inst != -1 and inst.object_index == obj_dough) {
		
		// dough is done baking
		if (inst.state == 1) {
			
			// decrease breadline
			if (bread_deadline - deadline_decrease_factor >= deadline_max) {
				bread_deadline -= deadline_decrease_factor;
				if (bread_deadline <= deadline_max) obj_player.spd *= 2;
			}
			
			// will create ammo by default
			var amount = choose(1, 2, 3);
			
			repeat (amount) {
				with (instance_create_layer(x, y, "Instances", obj_item)) {
					toss(15, x + (15 * irandom_range(-3, 3)), y - (15 * irandom_range(2, 5)));
				}
			}
		} else {
			screen_shake(10, 10);
			
			// spawn things
			obj_enemy_spawner.spawn_a_few(x, y, 1, 2);
			
		}
		// destroy dough
		instance_destroy(inst);
		obj_player.current_item = -1;
		timer = 0;
	}
}