/// @description state related functions

function return_to_idle() {
	state = enemy_states.idle;
	spd = walking_spd;
	fatigue = 0;
	moveX = 0;
	//moveY = 0;
	//show_debug_message("return to idle");
}


function state_idle() {
	moveX = 0;
	
	counter += 1;
	
	reduce_fatigue();
	
	//transition triggers
	if (counter/room_speed >= 3) {
		var cc = choose(0, 1);
		
		switch (cc) {
			case 0:
				state = enemy_states.wandering;
				dir = irandom_range(0, 359);
				moveX = choose(-1, 1) * spd;
				//moveY = lengthdir_y(spd, dir);
				//show_debug_message("counter switched to wandering");
				
			case 1: counter = 0; break;
		}
	}
	
	
	if (collision_circle(x, y, detect_radius, obj_player, false, false) or took_damage) {
		state = enemy_states.alert;
		set_knife(false, false, true);
		spd = chasing_spd;
	}
	
	
}

function state_wandering() {
	counter += 1;
	
	reduce_fatigue();
	
	
	//transition triggers
	if (counter/room_speed >= 3) {
		var cc = choose(0, 1);
		switch (cc) {
			case 0: state = enemy_states.idle;
			case 1:
				dir = irandom_range(0, 359);
				
				moveX = choose(-1, 1) * spd;
				counter = 0;
				break;
		}
		
		if (collision_circle(x, y, detect_radius, obj_player, false, false) or took_damage) {
			state = enemy_states.alert;
			set_knife(false, false, true);
			spd = chasing_spd;
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
	
	dir = point_direction(x, y, obj_player.x, obj_player.y);
	moveX = sign(obj_player.x - x) * spd;
	
	// jump of platform if player is 20 pixels below thing
	if (obj_player.y - y > 20) jump_off_platform();
	
	var d_radius = detect_radius;
	if (took_damage and dmg_timer/room_speed < 2) d_radius *= 5; //increase radius if shot
	
	var halfway_radius = (detect_radius - attack_radius) * 0.5;
	var _rotate = false;
	//if (collision_circle(x, y, halfway_radius, obj_player, false, false)) _rotate = true;
	
	set_knife(true, _rotate, true);
	
	// do rotate set to true here
	
	//transition triggers
	if (collision_circle(x, y, attack_radius, obj_player, false, false)) {
		state = enemy_states.attack;
		
		
	} else if (!collision_circle(x, y, d_radius, obj_player, false, false)) {
		if (instance_exists(knife_inst)) instance_destroy(knife_inst);
		knife_inst = -1;
		return_to_idle();
	}
}

function state_attack() {
	moveX = 0;
	
	//do rotate previously set to true
	set_knife(true, false, false);
	
	var attack_len = sprite_get_number(enemy_sprite_array[enemy_states.attack]);
	var attack_end = attack_len - 1;
	var cur_frame = draw_frame/room_speed;
	
	if (!collision_circle(x, y, attack_radius, obj_player, false, false) and cur_frame >= attack_end) {
		if (instance_exists(knife_inst)) instance_destroy(knife_inst);
		knife_inst = -1;
		return_to_idle();
		
	}
	
}