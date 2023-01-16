if (global.game_pause) exit;

// set visible/not visible
if (interval_id != -1) {
	// check if near box
	var nearbox;
	mask_index = spr_ingrbox_mask;
	if (!place_meeting(x, y, obj_player)) nearbox = false;
	else nearbox = true;
	mask_index = spr_ingrbox;
	
	// check if others are visible
	var others_active = false;
	with (obj_interval) {
		if (visible) others_active = true;
	}
	
	// set interval to invisible if not using it
	if (interval_id.visible and (!nearbox or keyboard_check_pressed(interact_key))) {
		interval_id.visible = false;
		interval_id.within_bounds = false;
		//show_debug_message("interval set to invisible");
	} else if (keyboard_check_pressed(interact_key)  and !others_active 
				and !interval_id.visible and nearbox) {
		interval_id.visible = true;
		//show_debug_message("interval id set to visible again");
	}
}

// create interval
if (place_meeting(x, y-10, obj_player) and keyboard_check_pressed(interact_key)) {
	
	if (obj_game.debugging) {
		// replace current interval and dispense ingredient
		if (interval_id != -1) {
			with (interval_id) instance_destroy();
			interval_id = -1;
		}
		dispense();
	}
	
	// one in two chance of getting an interval
	var chance = 3;
	if (!obj_game.less_intervals) chance = 1;
	
	var j = irandom_range(1, chance);
	
	if (j == 1) {
	
		// create interval
		//check if others are active
		var others_active = false;
		with (obj_interval) {
			if (visible) others_active = true;
		}
		
		if (interval_id == -1 and !others_active) {
			interval_id = obj_game.create_interval(x, y + 20);
			with (interval_id) ingrbox_id = other.id;
		}
	} else if (interval_id == -1) {
		dispense();
		
	}
}

