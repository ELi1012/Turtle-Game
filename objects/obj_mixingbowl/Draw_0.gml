
//-------- DRAWING BOWL
// draw back of bowl
draw_sprite(spr_bowl, 0, x, y);

// check if mouse is over bowl
var mouse_on_bowl = false;
mask_index = spr_bowl_mask;
if (collision_point(mouse_x, mouse_y, obj_mixingbowl, false, false) == id) mouse_on_bowl = true;
mask_index = spr_bowl;

if (state == baking_states.scavenging) {
	//draw ingr in list
	var ds_bye = disappear_ingr;
	var ds_len = ds_list_size(ds_bye)

	var i = 0;
	repeat (ds_len) {
		var inst = ds_bye[| i];
	
		//draw each ingredient in the list
		with (inst) {
			event_perform(ev_draw, 0);
		
			//when it has fallen past the opening of the bowl
			if (!place_meeting(x, y, obj_mixingbowl) and y > other.bbox_bottom) {
				//delete from list and destroy	
				ds_list_delete(other.disappear_ingr, i);
				i--;
				instance_destroy();
			}
		}
		i++;
	}
	
	//------------- UI

	//check if near bowl

	if (mouse_on_bowl) {
		// SHOW LIST
		//draw background
		draw_sprite(spr_bowl_list, 0, listx, listy);
	
		// draw 6 cells
		var i = 0;
		var ri = required_ingr;
		
		var starting_x = listx + 32;
		var starting_y = listy + 32;
		var ingr_xoffset = sprite_get_xoffset(spr_ingr);
		var ingr_yoffset = sprite_get_yoffset(spr_ingr);
		
		var cell_size = 64;
		var celldist_x = 32;
		var celldist_y = 48;
		var h_cellnum = 3;
		var cx, cy;
	
		repeat (array_length(ri)) {
			cx = starting_x + ((i mod h_cellnum) * (cell_size + celldist_x));
			cy = starting_y + ((i div h_cellnum) * (cell_size + celldist_y));
			var cx_middle = cx + (cell_size/2);
			var cy_bottom = cy + cell_size + 15;
		
			//draw cell then ingredient
			draw_sprite(spr_list_cell, 0, cx, cy);
			draw_sprite(spr_ingr, i, cx + ingr_xoffset, cy + ingr_yoffset);
		
			//draw number/checkmark
			var current_num = inbowl_ingr[i];
			if (current_num == ri[i]) draw_sprite(spr_list_check, 0, cx_middle, cy_bottom);
			else {
				draw_set_font(fnt_list);
				draw_set_halign(fa_center);
				draw_text(cx_middle, cy_bottom, string(current_num) + "/" + string(ri[i]));
				draw_set_font(fnt_default);
				draw_set_halign(fa_left);
			}
		
			i += 1;
		}
	}

} else if (state == baking_states.kneading) {
	// check if player is in bowl
	if (in_bowl) {
		// draw player in this event so it shows up behind front of bowl
		with (obj_player) event_perform(ev_draw, 0);
	} else if (mouse_on_bowl) {
		draw_sprite(spr_bowl_notif, 0, listx, listy);
	}
	
} else if (state == baking_states.resting) {
	var bowl_ind = 2;
	if (done_resting) bowl_ind = 3;
	
	draw_sprite(spr_bowl, bowl_ind, x, y);
	
	
	if (mouse_on_bowl) {
		
		if (done_resting) {
			var xx = cornerx + (spr_width/2);
			var yy = cornery - 10;
			obj_ui.interact_anim(xx, yy);
			
		} else {
			draw_sprite(spr_bowl_notif, 1, listx, listy);
		}
		
		
	}
	
}

//draw front of bowl
if (state != baking_states.resting) draw_sprite(spr_bowl, 1, x, y);






















