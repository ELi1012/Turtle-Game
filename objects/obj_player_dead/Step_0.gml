event_inherited();

if (global.game_pause) exit;


var rspeed = abs(power(slowe_down, 2) * (1/4));
room_speed = clamp(rspeed, 15, 60);
if (rspeed > 10000) instance_destroy();
		
slowe_down += 1/2;

obj_player.x = x;
obj_player.y = y;

if (!dropmove and !done) {
		
	done = true;
	image_index = 1;
	obj_ui.death_screen = true;
	
	

}