if (global.game_pause) exit;

off_platform = false;
switch (state) {
	case 0: state_idle(); break;
	case 1: state_wandering(); break;
	case 2: state_alert(); break;
}

moveY += grv;

/*
switch (state) {
	case 0: show_debug_message("idle"); break;
	case 1: show_debug_message("wandering"); break;
	case 2: show_debug_message("alert"); break;
	case 3: show_debug_message("attack"); break;
}
*/


// hesitate if picking up item
if (picking_up) moveX = 0;



var xx = x - sprite_get_xoffset(enemy_sprite_mask);
var yy = y - sprite_get_yoffset(enemy_sprite_mask);
var bullet_inst = collision_rectangle(xx + 16, yy + 16, xx + cell_size - 32, yy + cell_size, obj_bullet, false, false);


if (bullet_inst != noone) {
	
	var bd, dc, bk, ddir;
	with (bullet_inst) {
		bd = bullet_dmg;
		dc = dmg_cooldown;
		bk = bullet_knockback;
		ddir = image_angle;
		instance_destroy();
	}
	take_damage(bd, dc, bk, ddir);
	dequip_item();
}






//now thats a lotta damage
if (took_damage) {
	moveX += knockback_x;
	moveY += knockback_y;
	
	knockback_x = lerp(knockback_x, 0, 0.3);
	knockback_y = 0;//lerp(knockback_y, 0, 0.3);
	
	
	//show_debug_message("knockback x " + string(knockback_x));
	//show_debug_message("knockback y " + string(knockback_y));
	
	dmg_timer += 1;
	
	if (dmg_timer/room_speed >= dmg_cooldown) {
		took_damage = false;
		dmg_timer = 0;
	}
	
}



//do a bounce function similar to item bounce when colliding while wandering

//------------COLLISION CHECK

// VERTICAL
if (moveY != 0) {
	// only check for platform collision if moving downwards
	
	if (place_meeting(x, y + moveY, obj_collision)) v_collision(obj_collision);
	else if (moveY > 0 and !off_platform and !place_meeting(x, y, obj_platform) and 
			place_meeting(x, y + moveY, obj_platform)) v_collision(obj_platform);
	
	
	// keep x movement consistent when in midair
	if (moveY != 0 and !place_meeting(x, y + moveY, obj_collision) and 
		!place_meeting(x, y + moveY, obj_platform)) {
			//show_debug_message("moveY " + string(moveY));
			// PUT BEFORE CHECKING Y COLLISION OTHERWISE IT WILL GET STUCK
			moveX = ground_spd + knockback_x;
		}
	
}

// HORIZONTAL
if (moveX != 0) {
	if (place_meeting(x + moveX, y, obj_collision)) {
		repeat (abs(moveX)) {
			if (!place_meeting(x + sign(moveX), y, obj_collision)) x += sign(moveX);
			else break;
		}
		
		// change direction if wandering
		// otherwise stop moving
		if (state == enemy_states.wandering) moveX = (sign(moveX) * spd) * -1;
		else moveX = 0;
		
		// if being chased then jump off
		if (state == enemy_states.alert) jump_off_platform();
		
	}
}



ground_spd = moveX;

// destroy object if out of room
if (y > room_height) {
	if (current_item != -1) {
		with (current_item) {
			x = 10;
			y = 10;
			can_be_picked = true;
		}
	}
	instance_destroy();
}



//apply movement
x += moveX;
y += moveY;