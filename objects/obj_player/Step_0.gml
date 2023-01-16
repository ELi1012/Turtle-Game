if (global.game_pause or is_dead) exit;

//------------ MOVEMENT
#region movement
move_right = keyboard_check(ord("D"));
move_left = keyboard_check(ord("A"));
move_up = keyboard_check_pressed(vk_space);
var off_platform = false;



//reset movement variables
moveX = 0;

//x movement
moveX = (move_right-move_left) * spd;

//gunkick
//IS SET TO 0 IN THE DRAW EVENT
//OTHERWISE ANIMATION WILL BE JANKY

moveX += gunkick_x;
moveY += gunkick_y;

//y movement
var platform_collision = false;
if (place_meeting(x, y+1, obj_platform)) platform_collision = true;

if (place_meeting(x, y+1, obj_collision) or 
	(platform_collision and !place_meeting(x, y, obj_platform))) {
	//jump off ground
	if (move_up) {
		
		if (keyboard_check(ord("S"))) {
			// down key pressed - move down off platform
			off_platform = true;
			moveY = 1;
			
			//check for bowl and its state
			if (place_meeting(x, y+1, obj_mixingbowl)) {
				with (instance_place(x, y+1, obj_mixingbowl)) {
					if (state == baking_states.kneading and !in_bowl) {
						jumped_in_bowl();
					}
				}
			}
			
		} else moveY = -jump_height;
	}
} else {
	//double jump
	//if (move_up and double_jumped) show_debug_message("already double jumped");
	if (move_up and !double_jumped) {
		moveY = -jump_height;
		double_jumped = true;
	}
	moveY += grv;
}



//collision check
if (moveX != 0 and place_meeting(x+moveX, y, obj_collision)) {
	//var inst = instance_place(x+moveX, y, obj_collision);
	repeat (abs(moveX)) {
		if (!place_meeting(x + sign(moveX), y, obj_collision)) x += sign(moveX);
		else break;
		
	}
	moveX = 0;
}

if (place_meeting(x, y+moveY, obj_collision)) {
	v_collision(obj_collision)
}

// check if colliding downwards with platform
// do not collide with platform if it is from a bowl
if (moveY > 0 and place_meeting(x, y+moveY, obj_platform)) {
	
	// check for bowl and its state
	if (place_meeting(x, y+moveY, obj_mixingbowl) or place_meeting(x, y, obj_mixingbowl)) {
		// 1: player is jumping onto bowl platform - do collision
		// 2: player is jumping into bowl while in kneading phase - intiate variables
		// 3: player is already in bowl - ignore collision
		
		if (place_meeting(x, y+moveY, obj_mixingbowl) and !place_meeting(x, y, obj_mixingbowl)) {
		var is_kneading = false;
		var inst = instance_place(x, y+moveY, obj_mixingbowl)
		if (inst.state == baking_states.kneading) is_kneading = true;
		
		if (!in_bowl) {
			//do collision
			if (!is_kneading and !off_platform) v_collision(obj_platform);
			
			//jump into bowl
			else if (is_kneading) inst.jumped_in_bowl();
			
		} //else ignore collision
		}
		
	} else if (!place_meeting(x, y, obj_platform)) {
		// dont get stuck inside platform
		double_jumped = false;
		//show_debug_message("no meeting between self and platform");
		// if not moving off of platform
		if (!off_platform) v_collision(obj_platform);
	
	}
	
	
	
} else if (moveY < 0 and in_bowl and place_meeting(x, y + 3, obj_collision)) {
	// moving upwards - double jump if in bowl
	// PAIN THE THE BEHIND FIXED
	double_jumped = false;
}



x += moveX;
y += moveY;

#endregion movement




//------------- ITEM HOLDING
#region item holding
if (current_item != -1) {
	//measuring throw
	if (measuring_throw) {
		var percent = (throw_timer/room_speed)/throw_max;
		if (mouse_check_button(mb_right)) {
			throw_timer += throw_sign;
			if (throw_timer >= throw_max*room_speed or throw_timer < 0) throw_sign *= -1;
			//show_debug_message("strength: " + string(throw_radius_max*percent));
		
		} else if (mouse_check_button_released(mb_right)){
			//release throw
			with (current_item) toss(other.throw_radius_max*percent, mouse_x, mouse_y);
			current_item = -1;
			measuring_throw = false;
			throw_timer = 0;
			throw_sign = 1;
			//show_debug_message("released");
			
		}
	} else if (mouse_check_button_pressed(mb_right)){// and place_meeting(x, y, par_item)) {
		//toss ingr
		measuring_throw = true;
		//show_debug_message("measuring throw");
	}
} else {
	//ingredient not equipped
	if (mouse_check_button_pressed(mb_right) and place_meeting(x, y, par_item)) {
		//equip ingredient
		var inst = instance_place(x, y, par_item);
		
		if (inst.can_be_picked) {
		
			current_item = instance_place(x, y, par_item);
		
			//in case its still moving
			with (current_item) {
				dropmove = false;
				hspd = 0;
				vspd = 0;
			}
			//show_debug_message("equipped with empty hands");
		}
	}
}
#endregion item holding

//---------------- ATTACK/DEFENSE
if (place_meeting(x, y, obj_item)) {
	var inst = instance_place(x, y, obj_item);
	var heart = hp_oneheart;
	
	// use if consumable
	if (inst.can_be_picked) {
		switch (inst.item_type) {
			case 0: // ammo
				with (obj_gun) {
					if (ammo < ammo_max) {
						equip_ammo();
						instance_destroy(inst);
					}
				}
				break;
			
			case 1: //full heart
			
		
			case 2: // half heart
				heart = hp_oneheart/2;
				if (hp < max_hp) {
					hp = min(max_hp, hp + hp_oneheart);
					heal_self = true;
					//show_debug_message("added to hp " + string(heart));
				}
			
				break;
		
		}
	
		instance_destroy(inst);
	}
	
}

if (took_damage or heal_self) {
	//increment invincibility timer
	dmg_timer += 1;
	hp_previous = lerp(hp, hp_previous, 0.97);
	
	if (dmg_timer/room_speed >= dmg_cooldown) {
		
		
		
		took_damage = false;
		heal_self = false;
		dmg_timer = 0;
		hp_alpha = 1;
	}
}











