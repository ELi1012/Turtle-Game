


if (instance_exists(obj_gun)) {
	var r = obj_gun.ammo_round;
	var bwidth = sprite_get_width(spr_bullets_ui);
	var bheight = sprite_get_height(spr_bullets_ui);
	var margin = 20 + bwidth;
	var current_ammo = obj_gun.ammo;
	var current_rounds = ceil(current_ammo/r);
	var bullet_x = gui_width - (margin * current_rounds);
	
	var ammo_outof_round, percent, h, spry;
	
	
	//show_debug_message(string(percent));
	//show_debug_message(string(spry));
	//show_debug_message(" ");
	
	
	for (var i = 0; i < current_rounds; i += 1) {
		current_ammo -= (r*i);
		
		ammo_outof_round = current_ammo - (r*((current_ammo-1) div r));
		percent = ammo_outof_round/r;
		
		h = bheight * percent;
		spry = ((r - ammo_outof_round)/r)*bheight;
		
		// for the first one draw the round being used
		if (i == 0) {
			draw_sprite(spr_bullets_ui, 1, bullet_x + (i*margin), bullets_y);
			draw_sprite_part(spr_bullets_ui, 0, 0, spry, bwidth, h, bullet_x + (i*margin), bullets_y + spry);
		} else {
			draw_sprite(spr_bullets_ui, 0, bullet_x + (i*margin), bullets_y);
		}
	}
	
}

// draw timer
var timer_width = 448;
var percent = (obj_submithole.timer/room_speed) / obj_submithole.bread_deadline;
var sheight = sprite_get_height(spr_submit_timer);
var sx = 64;
var draw_width = timer_width - (timer_width*percent);

draw_sprite(spr_submit_timer, 1, 10, 10);
draw_sprite_part(spr_submit_timer, 0, sx, 0, draw_width, sheight, 10 + sx, 10);




if (victory_screen or death_screen) {
	
	draw_set_alpha(0.8);
	draw_set_color(c_black);
	draw_rectangle(0, 0, gui_width, gui_height, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	//draw title text
	draw_set_font(fnt_default_big);
	draw_set_halign(fa_center);
	
	var title_text;
	var title_x = gui_width/2;
	var title_y = 200;
	
	if (victory_screen) title_text = "You won";
	else if (death_screen) title_text = "You died";
	
	draw_text(title_x, title_y, string(title_text));
	
	
	
	//draw small text
	draw_set_font(fnt_default);
	var text_height = string_height("H");
	var smalltext_y = title_y + text_height + 50;
	
	draw_text(title_x, smalltext_y, "press any key to return to main menu");
	
	
	
	
	draw_set_halign(fa_left);
	draw_set_font(fnt_default);
	
} else if (global.game_pause) {
	
	draw_set_alpha(0.6);
	draw_set_color(c_black);
	draw_rectangle(0, 0, gui_width, gui_height, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	
	
	// draw text
	if (!view_tutorial) {
	draw_sprite(spr_pause, 0, pause_x, pause_y);
	
	draw_set_font(fnt_default_big);
	draw_set_halign(fa_middle);
	
	draw_text(text_x, pause_y + 30, "GAME PAUSED");
	
	draw_set_font(fnt_default);
	draw_text(text_x, pause_y + 180, "Press Q to view tutorial");
	
	draw_set_halign(fa_left);
	
	} else {
		draw_sprite(spr_tutorial, tutorial_page, tx, ty)
		
	}
	
	
	
	
	
}