/// @description state related functions

function return_to_idle() {
	state = enemy_states.idle;
	spd = walking_spd;
	fatigue = 0;
	moveX = 0;
	//show_debug_message("return to idle");
	//show_debug_message(" ");
}


function state_idle() {
	moveX = 0;
	
	counter += 1;
	
	reduce_fatigue();
	
	// pick up item
	if (place_meeting(x, y, par_item)) {
		var j = choose(1, 2, 3);
		if (j == 1) {
			equip_item();
			
		}
	}
	
	
	//transition triggers
	if (counter/room_speed >= 3) {
		var cc = choose(0, 1);
		
		switch (cc) {
			case 0:
				state = enemy_states.wandering;
				moveX = choose(-1, 1) * spd;
				//show_debug_message("counter switched to wandering");
				
			case 1: counter = 0; break;
		}
	}
	
	
	if ((current_item != -1 and collision_circle(x, y, detect_radius, obj_player, false, false)) or took_damage) {
		state = enemy_states.alert;
		spd = chasing_spd;
		//show_debug_message("(idle) player detected/took damage - switching to alert");
	} else if (current_item == -1 and collision_circle(x, y, detect_radius/2, par_item, false, false)) {
		detected_item = true;
		state = enemy_states.alert;
		spd = chasing_spd;
		//show_debug_message("(idle) item detected - switching to alert");
	}
	
	
}

function state_wandering() {
	counter += 1;
	
	reduce_fatigue();
	
	// pick up item
	if (place_meeting(x, y, par_item)) {
		var j = choose(1, 2, 3);
		if (j == 1) {
			equip_item();
			
		}
	}
	
	//transition triggers
	if (counter/room_speed >= 3) {
		var cc = choose(0, 1);
		switch (cc) {
			case 0: state = enemy_states.idle;
			case 1:
				
				moveX = choose(-1, 1) * spd;
				counter = 0;
				break;
		}
		
		if ((current_item != -1 and collision_circle(x, y, detect_radius, obj_player, false, false)) or took_damage) {
			state = enemy_states.alert;
			spd = chasing_spd;
			//show_debug_message("player detected/took damage - switching to alert");
		} else if (current_item == -1 and collision_circle(x, y, detect_radius/2, par_item, false, false)) {
			detected_item = true;
			state = enemy_states.alert;
			spd = chasing_spd;
			//show_debug_message("item detected - switching to alert");
		}
		
	}
}

function state_alert() {
	
	var f_current = (fatigue_timer - (fatigue * room_speed))/room_speed; //in seconds
	
	if (fatigue <= fatigue_limit) {
		fatigue_timer += 1;
		
		if (f_current >= fatigue_max) {
			fatigue += 1;
			spd -= fatigue mod 2;
		}
	}
	
	
	// run away from player ONLY IF ALREADY EQUIPPED ITEM
	
	// if running away
	// need a timer otherwise movement is janky
	if (start_running) {	
		moveX = sign(x - obj_player.x) * spd;
		
		// if player is right next to enemy then jump off platform
		if (place_meeting(x, y, obj_player)) {
			jump_off_platform();
		}
	}
	
	
	if (current_item != -1 and !start_running and 
		collision_circle(x, y, detect_radius, obj_player, false, false)) {
		start_running = true;
		
		// alarm sets start running to false
		var running_time = 3;
		alarm[0] = running_time * room_speed;
		
		//show_debug_message("start running away from player while item is equipped");
		
	} else if (detected_item) {
		// run towards item
		var i = collision_circle(x, y, detect_radius/2, par_item, false, false);
		
		if (i == noone) {
			detected_item = false;
			//show_debug_message("in alert: no more detected item");
			//return_to_idle();
		} else {
			//show_debug_message("running towards item");
			
			// pick up item
			if (place_meeting(x, y, par_item)) {
				equip_item();
			} else {
				moveX = sign(i.x - x) * spd;
			}
		}
	}
	
	
	var d_radius = detect_radius;
	if (took_damage and dmg_timer/room_speed < 2) d_radius *= 5; //increase radius if shot
	
	// return to idle if no item detected or not near player while holding item
	
	if (current_item == -1 and !detected_item) {
		//show_debug_message("no item detected - back to idle");
		return_to_idle();
		
	} else if (current_item != -1 and !start_running and !collision_circle(x, y, d_radius, obj_player, false, false)) {
		//show_debug_message("item held and not near player - back to idle");
		return_to_idle();
	
	}
	
}