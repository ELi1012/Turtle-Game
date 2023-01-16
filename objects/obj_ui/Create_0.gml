gui_width = global.game_width;
gui_height = global.game_height;

pause_x = (gui_width/2) - (sprite_get_width(spr_pause)/2);
pause_y = (gui_height/2) - (sprite_get_height(spr_pause)/2);

text_x = pause_x + (sprite_get_width(spr_pause)/2);

victory_screen = false;
death_screen = false;

view_tutorial = false;
tutorial_len = sprite_get_number(spr_tutorial);
tutorial_page = 0;

tx = (gui_width/2) - (sprite_get_width(spr_tutorial)/2);
ty = (gui_height/2) - (sprite_get_height(spr_tutorial)/2);

bullets_x = gui_width - sprite_get_width(spr_bullets_ui) - 30;
bullets_y = 30;

anim_timer = 0;

function interact_anim(_x, _y) {
		
	var anim_speed = 8;
	var anim_len = sprite_get_number(spr_interact);
	
	var subimg = anim_timer/room_speed;
	if (subimg >= anim_len) anim_timer = 0;
	anim_timer += anim_speed;
	
	draw_sprite(spr_interact, floor(subimg), _x, _y);
	
}