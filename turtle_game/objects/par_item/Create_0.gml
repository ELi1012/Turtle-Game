dropmove = true;
toss_below_platform = false;
can_be_picked = true;

//dropped
hspd = 0;
vspd = 0;
grv = 0.4;

//just do dropmove for dropping

function toss(_radius, _x, _y) {
	var dir = point_direction(x, y, _x, _y);
	var player_height = sprite_get_height(spr_player_mask);
	dropmove = true;
	hspd = lengthdir_x(_radius, dir);
	vspd = lengthdir_y(_radius, dir);
	
	
	
		var offset = 5;
		if (object_index == obj_dough) offset = 30;
		
		
		if (vspd >= 10 and place_meeting(x + hspd, y + player_height + offset, obj_platform)) {
			toss_below_platform = true;
			//show_debug_message("below");
		}
		
	
	//show_debug_message("hspd "+string(hspd));
	//show_debug_message("vspd "+string(vspd));
}

function v_collision(_obj_to_check) {
	if (!toss_below_platform) {
		repeat (abs(vspd)) {
			if (!place_meeting(x, y + sign(vspd), _obj_to_check)) y += sign(vspd);
			else break;
		}
		vspd = 0;
	}
	toss_below_platform = false;
}