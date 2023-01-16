if (global.game_pause or is_dead) exit;

//draw_rectangle(bbox_right, bbox_top, bbox_left, bbox_bottom, true);
// player animation

var frame_size = cell_size;
var anim_length = 3;
var anim_speed = 10;

//CONTROLS

var mx = moveX - gunkick_x;
if (mx > 0) y_frame = 0
else if (mx < 0) y_frame = 1
else if	(moveY == 0)	x_frame = 0

var xx = x - x_offset;
var yy = y - y_offset;

var fx = floor(x_frame)*frame_size;
var fy = y_frame*frame_size;

gunkick_x = 0;
gunkick_y = 0;
	

// y_frame determines type of walk cycle not y direction


//DRAWING
draw_sprite_part(spr_player_spritesheet, 0, fx, fy, frame_size, frame_size, xx, yy);
	
//FRAMES
x_frame += anim_speed/60;
if (x_frame >= anim_length) x_frame = 1;





//gun draws itself on top of player
var xscale = 1;
var dir = point_direction(x, y, mouse_x, mouse_y);
if (y_frame == 1) {
	xscale = -1;
	
}

//draw_sprite_ext(spr_gun, 0, obj_gun.x, obj_gun.y, xscale, 1, dir, c_white, 1);


with (obj_gun) {
	//image_xscale = 1;
	//if (other.y_frame == 1) image_xscale = -1;
	
	draw_self();
}

draw_sprite_part(spr_player_spritesheet, 1, fx, fy, frame_size, frame_size, xx, yy);

//draw throwing arrow if throwing
if (measuring_throw) {
	var yy = y - 40;
	var dir = point_direction(x, yy, mouse_x, mouse_y);
	var percent = (throw_timer/room_speed)/throw_max;
	var xx = x + lengthdir_x(10, dir);
	yy = yy + lengthdir_y(10, dir);
	
	draw_sprite_ext(spr_throw_arrow, 0, xx, yy, percent, 1, dir, c_white, 1);
}

//check for damage
if (took_damage or heal_self) {
	var xx = x - sprite_get_xoffset(spr_player_mask);
	var yy = y - sprite_get_yoffset(spr_player_mask);
	
	var hx = (xx + (cell_size/2)) - (hp_width/2);
	var hy = yy - hp_height - 15;
	
	var hp_margin = 10;
	var hp_wd = 64 - (hp_margin* 2);
	var hp_show = (hp_previous/max_hp) * hp_width;
	
	//only count the part of the sprite without margins
	var hp_full_hearts = (hp_show - (hp_margin * 2 * hp_hearts)) div (hp_hearts * hp_wd);
	var hp_final = hp_margin + (hp_full_hearts * hp_wd) + ((hp_full_hearts - 1) * (hp_margin * 2)) + ((hp_show - (hp_full_hearts * hp_wd)));
	
	//adjust alpha value if timer goes beyond a certain point
	var alpha_point = dmg_cooldown * 0.75;
	var alpha_speed = 0.1;
	
	if (dmg_timer/room_speed >= alpha_point) hp_alpha -= alpha_speed;
	
	draw_set_alpha(hp_alpha);
	draw_sprite(spr_hp, 1, hx, hy);
	draw_sprite_part(spr_hp, 0, 0, 0, hp_final, hp_height, hx, hy);
	draw_set_alpha(1);
	
}