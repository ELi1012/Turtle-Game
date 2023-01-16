ingredient = bread_ingredience.yeast;
interval_id = -1;

// drawing
spr_width = sprite_get_width(spr_ingrbox);
spr_height = sprite_get_height(spr_ingrbox);
spr_xoffset = sprite_get_xoffset(spr_ingrbox);
spr_yoffset = sprite_get_yoffset(spr_ingrbox);

cornerx = x - spr_xoffset;
cornery = y - spr_yoffset;

label = irandom_range(0, sprite_get_number(spr_box_label) - 1);
labelx = 52 + cornerx;
labely = 28 + cornery;

ingrx = labelx + 16 + sprite_get_xoffset(spr_ingr);
ingry = labely + 4 + sprite_get_yoffset(spr_ingr);

interact_key = ord("E");

function dispense() {
	with (instance_create_layer((x-spr_xoffset) + (spr_width/2), (y-spr_yoffset) + (spr_height/2), 
	"Instances", obj_ingr)) {
		ingredient = other.ingredient;
		//show_debug_message(string(image_index));
		toss(10, x + irandom_range(-5, 5), y - irandom_range(10, 20));
	}
}