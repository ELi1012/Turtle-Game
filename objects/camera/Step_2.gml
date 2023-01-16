#macro view view_camera[0]
camera_set_view_size(view, view_width, view_height);

if (instance_exists(obj_player)) {
	//subtract a bit from y to see more of above
	var yoffset = 70;
	
	//set camera x and y
	var _x = clamp(obj_player.x - (view_width/2), 0, room_width - view_width);
	var _y = clamp(obj_player.y - (view_height/2) - yoffset, 0, room_height - view_height);
	
	
	
	// shake camera
	if (shake_remain >= 0) {
		_x += random_range(-shake_remain, shake_remain);
		_y += random_range(-shake_remain, shake_remain);
		
		shake_remain = max(0, shake_remain - (shake_magnitude/shake_length));
	}
	
	camera_set_view_pos(view, _x, _y);
}