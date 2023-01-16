if (!visible or global.game_pause) exit;

//draw basics
draw_sprite(spr_interval, 0, x, y);
draw_sprite(spr_clef, clef, clefx, clefy);


//draw interval name
draw_sprite(spr_quality, quality, qx, qy);
draw_sprite(spr_dist, distance - 1, dx, dy);




var i = 0;

//---------NOTE DRAWING
#region note drawing
// draw given notes
var bx = bottom_notex;
var by = base_notey - bottom_notey;

var tx = top_notex;
var ty = base_notey - top_notey;


//draw bottom note
draw_note(ds_notes[# 0, 0], bx, by, ds_notes[# 2, 0], ds_notes[# 1, 0]);

//draw top note
//draw_note(ds_notes[# 0, 1], tx, ty, ds_notes[# 2, 1], ds_notes[# 1, 1]);


// draw player given note
var acc_dist = (ds_notes[# 2, 2] == 0) ? 0 : 30;
var px = (input_distance > 2) ? bottom_notex : bottom_notex + sprite_get_width(spr_note) + 10 + acc_dist;
var py = base_notey - player_notey;

draw_note(ds_notes[# 0, 2], px, py, ds_notes[# 2, 2], ds_notes[# 1, 2]);


#endregion note drawing

//---------TABS
// draw 4 tabs
var tab_num = sprite_get_number(current_display);
var tab_locked = 0;
// if currently on tab that is not available draw subimg 1 (greyed out)
for (i = 0; i < 4; i++) {
	tab_locked = ((i-1) < tab_num) ? 0 : 1;
	draw_sprite(spr_tab, tab_locked, tabx, taby + (i*tab_height));
}

// tab switcher
draw_sprite(spr_tab_switch, 0, tabx, taby);

// display current category choices
for (i = 0; i < tab_num; i++) {
	draw_sprite(current_display, i, tabx, taby + tab_height + (i*tab_height));
}

// draw arrow
if (within_bounds) {
	var mtab = (mouse_y - taby) div tab_height;
	//check if mtab is greater than current number of tabs
	if (mtab > current_tab_num) mtab -= 1;
	
	var subimg = anim_timer/room_speed;
	var anim_speed = 12;
	
	anim_timer += anim_speed;
	if (anim_timer/room_speed >= sprite_get_number(spr_arrow)) anim_timer = 0;
	
	draw_sprite(spr_arrow, floor(subimg), tabx + tab_width, taby + (tab_height/2) + (mtab * tab_height));
}