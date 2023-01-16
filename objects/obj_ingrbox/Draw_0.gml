draw_sprite(spr_ingrbox, 0, x, y);
draw_sprite(spr_box_label, label, labelx, labely);
draw_sprite(spr_ingr, ingredient, ingrx, ingry);

// draw interact key

// wow thats risky
if (place_meeting(x, y-10, obj_player)) {
	var display = false;
	if (interval_id == -1) display = true;
	else if (!interval_id.visible) display = true;
	
	if (display) {
		var interactx = cornerx + (spr_width/2);
		var interacty = cornery - 20;
		
		obj_ui.interact_anim(interactx, interacty);
	}
}