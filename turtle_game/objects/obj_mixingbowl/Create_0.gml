//states
state = baking_states.scavenging;



//data
disappear_ingr = ds_list_create();



inbowl_ingr = [
	//ratio of flour to water is roughly 5/3
	0,
	0,
	0,
	0,
	0,
	0
];

required_ingr = [
	//ratio of flour to water is roughly 5/3
	2,
	1,
	1,
	1,
	2,
	1
];



//-----UI
spr_xoffset = sprite_get_xoffset(spr_bowl);
spr_yoffset = sprite_get_yoffset(spr_bowl);
spr_width = sprite_get_width(spr_bowl);
spr_height = sprite_get_height(spr_bowl);

cornerx = x - spr_xoffset;
cornery = y - spr_yoffset;

// relative to bowl
listx = cornerx + (spr_width/2) - (sprite_get_width(spr_bowl_list)/2);
listy = cornery - (spr_yoffset + 40);


// dough

in_bowl = false;

dough_y = cornery + 116;
dough_y_maxdist = dough_y + 30;
dough_id = -1;

total_force = 0;
force_needed = 15 * 5; //max strength 15, 5 times
//total_force = force_needed - 2


timer = 0;
resting_time = 20; // in seconds
done_resting = false;

interact_key = ord("E");


function create_dough() {
	var cwidth = sprite_get_width(spr_collision);
	//var cheight = sprite_get_height(spr_collision);
	var dwidth = sprite_get_width(spr_dough_mask);
	var bowl_middle = cornerx + (spr_width/2);
	
	dough_id = instance_create_layer(bowl_middle - (cwidth/2), dough_y, "Instances", obj_collision);
	with (dough_id) {
		image_xscale = dwidth/cwidth;
		image_yscale = 1/100;//sprite_get_height(spr_dough_mask)/cheight;
		x = bowl_middle - (dwidth/2)
		visible = false;
	}
}

//create_dough();

function jumped_in_bowl() {
	show_debug_message("jumped in bowl");
	create_dough();
	
	in_bowl = true;
	obj_player.in_bowl = true;
	obj_player.visible = false;
	
	instance_create_layer(x, y, "Bowl", obj_bowl_kmask);
	
}

function not_in_bowl() {
	show_debug_message("out of bowl");
	in_bowl = false;
	obj_player.in_bowl = false;
	obj_player.visible = true;
	
	if (dough_id != -1) {
		with (dough_id) instance_destroy();
		//show_debug_message("dough destroyed");
		dough_id = -1;
	}
	if (instance_exists(obj_bowl_kmask)) with (obj_bowl_kmask) instance_destroy();
}




