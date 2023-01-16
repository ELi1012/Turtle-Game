draw_sprite(spr_submithole, 0, x, y);

/*
if (place_meeting(x, y, obj_player) and obj_player.current_item != -1) {
	var inst = obj_player.current_item;
	if (inst != -1 and inst.object_index == obj_dough) {
		var yy = y - (sprite_get_height(spr_submithole)/2) - 10;
		
		obj_ui.interact_anim(x, yy);
	}
}