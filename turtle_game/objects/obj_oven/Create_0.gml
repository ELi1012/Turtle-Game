interact_key = ord("E");


oven_shelf = -1;
dough_thing = -1;
dough_y = 0;


// oven subimg determines state of oven
// 0: closed
// 1: open
// 2: baking
// 3: done

oven_state = 0;


timer = 0;
baking_time = 10; // in seconds
timer_speed = 1;

function create_oven_shelf() {
	var sx = x - sprite_get_xoffset(spr_oven) + 42;
	var sy = y - sprite_get_yoffset(spr_oven) + 554;
	var w = sprite_get_width(spr_platform); //make it 550 wide
	oven_shelf = instance_create_layer(sx, sy, "Bowl", obj_platform);
	with (oven_shelf) {
		
		image_xscale = 550/w;
		image_yscale = 1/4;//1/sprite_get_height(spr_platform);
		//x = (x-sprite_get_xoffset(spr_oven)) + 150;
	}
}