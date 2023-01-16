if (!visible or global.game_pause) exit;

//destroy if pressing shift while clicking
if (keyboard_check_pressed(vk_shift) and mouse_check_button_pressed(mb_left) 
	and instance_place(mouse_x, mouse_y, obj_interval) == id) {
	instance_destroy();
	exit;
}


//----------CHECKING ANSWER
if (keyboard_check_pressed(confirm_key)) {
	// check if data for player input matches top note
	var correct;
	if (ds_notes[# 0, 2] == ds_notes[# 0, 1] and ds_notes[# 2, 2] == ds_notes[# 2, 1]) {
		correct = true;
		// dispense ingredience
		with (ingrbox_id) dispense();
		
	} else {
		correct = false;
		screen_shake(10, 10);
		
		obj_enemy_spawner.spawn_a_few(x, y - 40, 1, 2);
		
	}
	// destroy self and set interval id to -1
	instance_destroy();
	with (ingrbox_id) interval_id = -1;
}


//----------TABS
var mx = mouse_x;
var my = mouse_y;

//if mouse is within bounds
if (mx >= tabx and mx < tabx + tab_width and my > taby and my < taby + (tab_height * 4)) {
	within_bounds = true;
	var mmy = my - taby;
	var mtab = mmy div tab_height;
	
	//player clicked on tab
	if (mouse_check_button_pressed(mb_left)) {
		if (mtab == 0) {
			// switch displays
			display_ind += 1;
			if (display_ind >= array_length(display_type)) display_ind = 0;
			update_display(display_type[display_ind]);
			
		} else {
			// select thing from tab
			var picked_tab = mtab - 1;
			switch (current_display) {
				//-----------adjusting distance/player note
				case spr_tab_num:
					var nnn = ds_notes[# 0, 2]; // player selected note
					var bn = ds_notes[# 0, 0] //bottom note
					if (picked_tab == 0) nnn += 1;
					else if (picked_tab == 1) nnn -= 1;
					
					// clef dependent
					if (nnn >= treble_notes.height) nnn = bn;
					else if (nnn < bn) nnn = treble_notes.height - 1;
					
					ds_notes[# 0, 2] = nnn;
					player_notey = nnn * note_dist;
					input_distance = abs(ds_notes[# 0, 0] - ds_notes[# 0, 2]) + 1;
					
					var shift_to_c = (clef == clef_type.treble) ? 6 : 1;
					ds_notes[# 1, 2] = (nnn + shift_to_c) mod 7;
					//show_debug_message("picked note " + string(nnn));
					
					break;
				
				//-------------adjusting accidental
				case spr_tab_acc:
					ds_notes[# 2, 2] = picked_tab;
					//show_debug_message("picked accidental " + string(picked_tab));
					break;
				
			}
		}
	}
} else {
	within_bounds = false
}