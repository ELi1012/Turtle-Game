

if (victory_screen or death_screen) {
	if (keyboard_check_pressed(vk_anykey)) game_restart();//room = rm_menu;
	
} else if (keyboard_check_pressed(vk_escape)) {
	global.game_pause = !global.game_pause;
	view_tutorial = false;
} else if (global.game_pause and keyboard_check_pressed(ord("Q"))) {
	alarm[0] = 1;
}

if (view_tutorial) {
	
	
	if (keyboard_check_pressed(vk_right)) {
		tutorial_page += 1;
		if (tutorial_page >= tutorial_len) tutorial_page = 0;
	} else if (keyboard_check_pressed(vk_left)) {
		tutorial_page -= 1;
		if (tutorial_page < 0) tutorial_page = tutorial_len - 1;
	} else if (keyboard_check_pressed(ord("P"))) {
		tutorial_page = 1;
		
	} else if (keyboard_check_pressed(ord("I"))) {
		tutorial_page = 5;
	
	
	} else if (keyboard_check_pressed(ord("Q"))) alarm[0] = 1;
}