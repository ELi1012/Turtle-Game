view_width = 840;
view_height = 640;

window_scale = 1.5;

global.game_width = view_width * window_scale;
global.game_height = view_height * window_scale;

window_set_size(view_width * window_scale, view_height * window_scale);
alarm[0] = 1;

surface_resize(application_surface, view_width * window_scale, view_height * window_scale);

shake_length = 0;
shake_magnitude = 0;
shake_remain = 0;
buff = 32;