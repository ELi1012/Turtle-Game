if (global.game_pause) exit;

if (keyboard_check(vk_shift)) timer_speed = 5;
else timer_speed = 1;

if (oven_state == 0) {
	// check if oven is open
	if (keyboard_check_pressed(interact_key) and place_meeting(x, y, obj_player)) {
		oven_state = 1;
		create_oven_shelf();
		//show_debug_message("opened");
	}
	
	
} else if (oven_state == 1) {
	// check if dough is thrown in oven
	var dough_in_oven = false;
	var player_on_shelf = false;
	
	with (oven_shelf) {
		var inst = instance_place(x, y - 1, obj_dough);
		if (inst != noone and inst != obj_player.current_item and !inst.dropmove) {
			//show_debug_message(string(object_get_name(inst.object_index)));
			
			// only pick up if being thrown
			// DONT FORGET OTHER
				dough_in_oven = true;
				other.dough_thing = inst;
				other.dough_y = inst.y;
				if (place_meeting(x, y - 1, obj_player)) player_on_shelf = true;
		}
		
		
	}
	
	if (dough_in_oven) {
		
		// make dough invisible and punt player up
		with (dough_thing) {
			visible = false;
			can_be_picked = false;
		}
		
		if (player_on_shelf) obj_player.gunkick_y = -(oven_shelf.y - y);
		with (oven_shelf) instance_destroy();
		
		// begin cooking
		oven_state = 2;
		show_debug_message("cooking");
		
	}
	
	
	
} else if (oven_state == 2) {
	// cooking
	timer += timer_speed;
	dough_thing.y = dough_y;
	if (timer/room_speed > baking_time) {
		oven_state = 3;
		timer = 0;
		
		with (dough_thing) {
			visible = true
			can_be_picked = true;
			state = 1;
			y = other.dough_y;
		}
		create_oven_shelf();
		//show_debug_message("done cooking");
	}
	
	
} else if (oven_state == 3) {
	//check if picked up dough
	
	if (obj_player.current_item == dough_thing) {
		// toss player
		obj_player.gunkick_y = -30;
			
		oven_state = 0;
		with (oven_shelf) instance_destroy();
		oven_shelf = -1;
	}
	/*	
	dough_thing.y = dough_y;
	if (mouse_check_button_pressed(mb_right)) {
		var picked_up = false;
		
		with (dough_thing) {
			if (place_meeting(x, y, obj_player)) picked_up = true;
		}
		
		if (obj_player.current_item == dough_thing) {
			// toss player
			obj_player.gunkick_y = -50;
			
			oven_state = 0;
			with (oven_shelf) instance_destroy();
			oven_shelf = -1;
		}
	}
	*/
}