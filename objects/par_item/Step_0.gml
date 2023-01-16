if (global.game_pause) exit;

//drop object
if (dropmove) {
	
	
	//apply gravity
	vspd += grv;
	
	//collision
	
	if (place_meeting(x + hspd, y, obj_collision)) {
		repeat (abs(hspd)) {
			if (!place_meeting(x + sign(hspd), y, obj_collision)) x += sign(hspd);
			else break;
		
		}
		hspd = 0;
		//slow down vertical movement to account for friction
		vspd = max(1, vspd - 3); //don't set to 0 otherwise will exit dropmove
	}
	
	// vertical collision for collision obj
	if (place_meeting(x, y + vspd, obj_collision)) v_collision(obj_collision);
	
	// vertical collision for platform obj
	// if item is not inside platform and platform is not a bowl and item is moving downwards
	if (place_meeting(x, y + vspd, obj_platform) and !place_meeting(x, y, obj_platform)
		and !place_meeting(x, y + vspd, obj_mixingbowl) and vspd > 0) v_collision(obj_platform);
	
	//apply friction if v collision
	if (vspd == 0) hspd = max(0, (abs(hspd) - 0.5) * sign(hspd));
	
	//stop moving if obj stopped moving in both directions/on ground
	if (hspd == 0 and vspd == 0) {
		if (place_meeting(x, y + 1, obj_collision)||place_meeting(x, y + 1, obj_platform)) {
			dropmove = false;
			toss_below_platform = false;
		}
	}
	
	
	x += hspd;
	y += vspd;
}