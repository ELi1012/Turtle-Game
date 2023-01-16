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

function equip_item() {
	// equip if: not holding item, havent recently taken damage, and near item
	if (current_item == -1 and !picking_up and !took_damage and place_meeting(x, y, par_item)) {
		var inst = instance_place(x, y, par_item);
		var p_item = obj_player.current_item;
		
		if (inst != p_item and inst.can_be_picked and !inst.dropmove and inst.vspd >= 0) {
			picking_up = true;
			item_to_pickup = inst;
			inst.can_be_picked = false;
			
			// put a safeguard in case item ceases to exist after calling alarm
			alarm[2] = 1.5 * room_speed;
		}
	}
}

function dequip_item() {
	if (current_item != -1) {
		//show_debug_message("dequipped item");
		with (current_item) {
			toss(irandom_range(10, 20), x + (5 * irandom_range(-5, 5)), y - 64);
			can_be_picked = true;
		}
		current_item = -1;
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
			var j = choose(1, 2, 3);
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
			
			dequip_item();
			screen_shake(10, 10);
			instance_destroy();
		
		}
	}
	dmg_flash = 3;
}

