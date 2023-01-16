if (global.game_pause) exit;

var xx = x - sprite_get_xoffset(enemy_sprite_mask);
var yy = y - sprite_get_yoffset(enemy_sprite_mask);

var esprite = enemy_sprite_array[state];
var anim_speed = sprite_get_speed(esprite);
var anim_len = sprite_get_number(esprite);
var ind = floor(draw_frame/room_speed);


var kx = (knockback) ? lerp(x, knockback_x, 0.2) - x : 0;
xscale = sign(moveX - kx);
if (xscale == 0) {
	xscale = sign(obj_player.x - x);
	if (xscale == 0) xscale = 1;
	
}


if (xscale == -1) xx = xx + cell_size;

if (state != prev_state) draw_frame = 0;



if (state == enemy_states.idle) {
	draw_sprite_ext(esprite, ind, xx, yy, xscale, 1, 0, c_white, 1);
	
	
} else if (state == enemy_states.wandering) {
	draw_sprite_ext(esprite, ind, xx, yy, xscale, 1, 0, c_white, 1);
	
	
	
} else if (state == enemy_states.alert) {
	draw_sprite_ext(esprite, ind, xx, yy, xscale, 1, 0, c_white, 1);
	with (obj_enemy_knife) draw_self();
	
} else if (state == enemy_states.attack) {
	draw_sprite_ext(esprite, ind, xx, yy, xscale, 1, 0, c_white, 1);
	with (obj_enemy_knife) draw_self();
	
}

if (dmg_flash > 0) {
	flash_div = dmg_flash;
	dmg_flash -= 1;
	
	shader_set(shd_flash);
	//gpu_set_blendmode(bm_add);
	draw_sprite_ext(esprite, ind, xx, yy, xscale, 1, 0, c_white, 1);
		
		
	if (instance_exists(knife_inst)) {
		with (obj_enemy_knife) draw_self();
	}
	
	shader_reset();
	//gpu_set_blendmode(bm_normal);
}

prev_state = state;
//draw_text(x, y + 128, string(fatigue_timer/room_speed));
//draw_text(x, y + 128 + 20, string(hp));



//increment frames
draw_frame += anim_speed;
if (draw_frame/room_speed >= anim_len) draw_frame = 0;