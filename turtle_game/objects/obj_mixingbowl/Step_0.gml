if (global.game_pause) exit;

//store ids of ingredience going into bowl
//show_debug_message("state " + string(state));
if (state == baking_states.scavenging) {
if (place_meeting(x, y, obj_ingr)) {
	var _list = ds_list_create();
	var _num = instance_place_list(x, y, obj_ingr, _list, false);
	if (_num > 0) {
	    for (var i = 0; i < _num; ++i;) {
	        var inst = _list[| i];
			
			// add to ds list if not already in it
			// IS IN INST OBJECT DO NOT FORGET
			// only consider if vspd > 0 (moving downwards)
			with (inst) {
				if (vspd > 0) {
					if (!in_bowl) {
						var itype = ingredient;
						var ingr_have = other.inbowl_ingr;
						var ingr_need = other.required_ingr;
					
						//already have enough of the ingredient
						if (ingr_have[itype] >= ingr_need[itype]) {
							//send alert
							//show_debug_message("rejected");
							var bowl_whalf = 50;//other.spr_width/2;
							var upwards_len = 150;
							var dir = sign(x - other.x);
							if (dir == 0) dir = 1;
							toss(20, other.x + (dir*bowl_whalf) + (dir*30*irandom_range(0, 3)),
								other.bbox_top + -(upwards_len)); //should be negative to go up
						} else {
							// add to bowl
							other.inbowl_ingr[itype] += 1;
							in_bowl = true;
							visible = false;
							ds_list_add(other.disappear_ingr, id);
						
							// check if ingredients in bowl match requirements
							var i = 0;
							var done = true;
							repeat (array_length(ingr_need)) {
								if (other.inbowl_ingr[i] != ingr_need[i]) {
									//show_debug_message("have " + string(other.inbowl_ingr[i]) + "need " + string(ingr_need[i]));
									done = false;
									break;
								}
								i += 1;
							}
						
							//------- SCAVENGING STATE DONE
							if (done) {
								other.state = baking_states.kneading;
							
								//reset variables
							
								for (var i = 0; i < array_length(ingr_need); i += 1) {
									other.inbowl_ingr[i] = 0;
								}
							}
						}
					}
				}
			}
	    }
	}
	ds_list_destroy(_list);
}
} else if (state == baking_states.kneading) {

// check if player is in bowl
if (in_bowl) {
	var force = obj_player.jump_force;
	
	
	
	
	// move dough
	with (dough_id) {
		//yy equals prospective y
		var dy = other.dough_y;
		var dymax = other.dough_y_maxdist;
		var stood_on = (place_meeting(x, y-1, obj_player)) ? true : false;
		var yy = y;
		
		
		//lower dough significantly if jumped on
		if (force >= 3) {
				yy += 5;
			
		} else {
			// raise dough if lower than set y dist
			// lower dough if being stood on
			if (!stood_on) yy -= 1;
			else yy +=2;
			
		}
		
		//apply movement
		if (yy < dy) yy = dy;
		else if (yy > dymax) yy = dymax;
		y = yy;
	}
	
	// check if player has jumped on dough
	if (force >= 3) {
		total_force += force;
		//show_debug_message("total force " + string(total_force));
		
		
		//--------- KNEADING STATE DONE
		if (total_force >= force_needed) {
			// move to next state
			state = baking_states.resting;
			total_force = 0;
			not_in_bowl();
			
			
		}
	}
	
	// check if player has jumped out of bowl
	// moves bowl if this code is put above
	if (obj_player.bbox_right < bbox_left or obj_player.bbox_left > bbox_right) {
		not_in_bowl();
	}
}


} else if (state = baking_states.resting) {
	
	
	// dough is taken out after resting
	if (done_resting) {
		//----------- take out dough
		if (keyboard_check_pressed(interact_key)) {
			mask_index = spr_bowl_mask;
			
			// reset variables
			if (place_meeting(x, y, obj_player)) {
				
				done_resting = false;
				state = baking_states.scavenging;
				with (instance_create_layer(x, cornery, "Dough", obj_dough)) {
					toss(10, x + (10 * irandom_range(-3, 3)), y - 20);
				}
			}
			
			mask_index = spr_bowl;
		}
	} else {
		
		timer += 1;
		
		//------- resting is done
		if (timer/room_speed >= resting_time) {
			// reset variables and spawn dough
			timer = 0;
			done_resting = true;
		}
	}
}

