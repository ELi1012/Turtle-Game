/// @description other functions


function v_collision(_obj_to_check) {
	repeat (abs(moveY)) {
		if (!place_meeting(x, y + sign(moveY), _obj_to_check)) y += sign(moveY);
		else break;
	}
	moveY = 0;
}

function jump_off_platform() {
	if (!just_off_platform) {
		var j = choose(1, 2, 3);	
		
		if (j == 1) {
			off_platform = true;
			just_off_platform = true;
			alarm[1] = 5 * room_speed;
		}
	}
}


function set_knife(already_created, do_rotate, _idle_animation) {
	var knife_xoffset = 18;
	var knife_yoffset = 34;
		
	var kx = x - sprite_get_xoffset(enemy_sprite_mask) + knife_xoffset;
	var ky = y - sprite_get_yoffset(enemy_sprite_mask) + knife_yoffset;
	var k_offset = 16; // range for lunging
	
	if (xscale == -1) kx = x - sprite_get_xoffset(enemy_sprite_mask) + cell_size - knife_xoffset;
	
	if (!already_created) knife_inst = instance_create_layer(kx, ky, "Instances", obj_enemy_knife);
	
	var player_angle = point_direction(x, y, obj_player.x, obj_player.y);
	var cur_frame = floor(draw_frame/room_speed);
	var attack_frame = 5;
	var attack_len = 2;
	var can_attack = (cur_frame >= attack_frame and cur_frame < attack_frame + attack_len) ? true : false;
	
	if (state == enemy_states.attack) {
		if (cur_frame >= attack_frame - 2 and cur_frame <= attack_frame - 1) {
			attack_dir = point_direction(x, y, obj_player.x, obj_player.y);
		}
		
		if (can_attack and !attack_dash) attack_dash = true;
		else if (!can_attack) attack_dash = false;
		
		if (attack_dash) {
			attack_dash = false;
			var dir = attack_dir;
			player_angle = attack_dir;
			do_rotate = true;
			
			moveX = 0;
			//moveY = 0;
			
			moveX += sign(obj_player.x - x) * dash_range;
			//moveY += lengthdir_y(dash_range, dir);
		}
	}
	
	
	with (knife_inst) {
		
		
		if (!do_rotate) {
			//snap player angle to 180 or 0 depending on its direction
			player_angle = (player_angle < 90 or player_angle > 270) ? 0 : 180;
			
		}
		
		if (player_angle >= 90 and player_angle <= 270) image_yscale = -1;
		else image_yscale = 1;
		
		
		if (place_meeting(x, y, obj_player) and other.state == enemy_states.attack and can_attack) {
			//knife is extended
			var _dmg = other.enemy_damage;
			var _dmg_spd = other.damage_spd;
			var _shake = other.enemy_screenshake;
			var angle = image_angle;
			
			x = kx + lengthdir_x(k_offset, player_angle);
			y = ky + lengthdir_y(k_offset, player_angle);
			
			obj_player.take_damage(_dmg, _dmg_spd, _shake, angle);
			//show_debug_message("damage: " + string(_dmg));
			
		} else {
			x = kx;
			y = ky;
		}
		
		image_angle = player_angle;
		if (_idle_animation) image_index = 0;
		else image_index = cur_frame;
	}
}


function reduce_fatigue() {
	
	//keep decreasing fatigue
	var _fm = fatigue_max * fatigue_limit; //how many seconds it takes to gain full fatigue
	var _subtract = _fm/fatigue_recover;
	
	if (fatigue_timer > 0) {
		fatigue_timer -= _subtract;
		fatigue_timer = max(fatigue_timer, 0);
		if (fatigue_timer/room_speed < fatigue * fatigue_max) fatigue -= 1;
	}
}


function take_damage(_dmg, _dmg_cooldown, _knockback, _dir) {
	//check if already took damage
	if (!took_damage) {
		took_damage = true;
		dmg_cooldown = _dmg_cooldown;
		hp -= _dmg;
		
		
		// knockback
		
		var multiplier = 2;
		var knockback_dirx = lengthdir_x(_knockback*multiplier, _dir); //sign(xdir);
		var knockback_diry = min(lengthdir_y(_knockback*multiplier, _dir), 0);
		
		
		// knockback is 4
		knockback_x = knockback_dirx;
		knockback_y = ((_knockback * multiplier) * -1) + (knockback_diry/2);
		//show_debug_message("knockback x " + string(knockback_x));
		//show_debug_message("knockback y " + string(knockback_y));
		
		if (hp <= 0) {
			
			// spawn some item
			var j = choose(1, 2);
			if (j == 1) {
				with (instance_create_layer(x, y - 30, "Instances", obj_item)) {
					item_type = irandom_range(0, sprite_get_number(spr_item) - 1);
					toss(10, x - (5 * irandom_range(-3, 3)), y - 10);
				}
			}
			
			var oDead = instance_create_layer(x, y, "Instances", obj_enemy1_dead);
			var rad = sqrt(sqr(knockback_x) + sqr(knockback_y));
			var xpoint = x + knockback_x;
			var ypoint = y - 30;//y + knockback_y;
			
			with (oDead) {
				toss(rad, xpoint, ypoint);
			}
			
			screen_shake(10, 10);
			if (knife_inst != -1) with (knife_inst) instance_destroy();
			instance_destroy();
		
		}
	}
	dmg_flash = 3;
}

