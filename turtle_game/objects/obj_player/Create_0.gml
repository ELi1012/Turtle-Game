moveX = 0;
moveY = 0;

gunkick_x = 0;
gunkick_y = 0;


spd = 5;
grv = 0.4;
jump_height = 10;
double_jumped = false;
jump_force = 0;
recent_jump = false;

//stats
max_hp = 120;
hp = 120;

if (obj_game.lower_difficulty) {
	max_hp = max_hp*2;
	hp = 120*2;
}


hp_width = sprite_get_width(spr_hp);
hp_height = sprite_get_height(spr_hp);
hp_hearts = hp_width/64;
hp_oneheart = max_hp/hp_hearts;
hp_previous = hp;
hp_alpha = 1;


// animation
cell_size = 128;
anim_timer = 0;
x_frame = 1;
y_frame = 0;

x_offset = sprite_get_xoffset(spr_player_mask);
y_offset = sprite_get_yoffset(spr_player_mask);



took_damage = false;

dmg_timer = 0;
dmg_cooldown = 2;

heal_self = false;

is_dead = false;
move_room = true; //////

current_item = -1;
measuring_throw = false;
throw_radius_max = 20;
throw_timer = 0;
throw_max = 1;
throw_sign = 1;

in_bowl = false;




//define functions
event_user(0);