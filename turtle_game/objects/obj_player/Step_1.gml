if (global.game_pause) exit;

//make ingredient follow player
if (current_item != -1) {
	with (current_item) {
		x = other.x;
		y = other.y - other.cell_size + 25;
	}
}