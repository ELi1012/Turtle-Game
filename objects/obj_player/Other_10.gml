/// @description storing functions

function v_collision(_obj_to_check) {
	repeat (abs(moveY)) {
		if (!place_meeting(x, y + sign(moveY), _obj_to_check)) y += sign(moveY);
		else break;
	}
	
	//if obj is collision OR obj is platform and platform is not a bowl
	if (_obj_to_check != obj_platform or (_obj_to_check == obj_platform and !in_bowl)) {
		jump_force = moveY;
		recent_jump = true;
		alarm[0] = 2; // set recent jump to false after 2 step
		moveY = 0;
	}
	double_jumped = false;
}





function take_damage(_dmg, _dmg_cooldown, _screenshake, _knockback_dir) {
	//exit if already took damage
	if (took_damage or in_bowl) exit;
	
	took_damage = true;
	dmg_cooldown = _dmg_cooldown;
	hp_previous = hp;
	hp -= _dmg;
	
	if (hp <= 0 and move_room) die(_knockback_dir);
	
	screen_shake(_screenshake, 30);
	
}




function die(_dir) {
	
	is_dead = true;
	visible = false;
	
	
	if (_dir < 90 or _dir > 270) _dir = 0;
	else _dir = 180;
	
	var inst = instance_create_layer(x, y, "Instances", obj_player_dead);
	with (inst) {
		//room_speed = 30;
		
		toss(20, x + (5 * irandom_range(-3, 3)), y - 20);
		
		player_sprite = spr_player_dead;
		sprite_index = player_sprite;
	}
	
	
}














