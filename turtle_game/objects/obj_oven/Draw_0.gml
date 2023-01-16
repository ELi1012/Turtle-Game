draw_sprite(spr_oven, oven_state, x, y);


if (oven_state == 0) {
	
	// draw e
	if (place_meeting(x, y - 20, obj_player)) {
		var ix = x;
		var iy = (y - sprite_get_yoffset(spr_oven)) - 20;
		
		obj_ui.interact_anim(ix, iy);
	}
	
} else if (dough_thing != -1 and oven_state == 2) {
	draw_sprite(spr_dough, 0, dough_thing.x, dough_thing.y);
	draw_sprite(spr_oven, oven_state, x, y);
}