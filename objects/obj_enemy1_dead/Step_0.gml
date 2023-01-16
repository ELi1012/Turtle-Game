event_inherited();

if (!dropmove) {
	image_index = 1;
	fade_timer += 1;
	var cur_timer = fade_timer/room_speed;
	
	if (cur_timer >= fade_start) {
		//fade_alpha -= (1/fade_max)/room_speed;
		image_alpha = lerp(image_alpha, 0, 0.2);
		
		if (fade_alpha <= 0) instance_destroy();
		
	}
}