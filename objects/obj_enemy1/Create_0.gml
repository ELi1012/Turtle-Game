state = choose(enemy_states.idle, enemy_states.wandering);
prev_state = state;

var diff = obj_game.difficulty;
var max_diff = obj_game.max_difficulty;
//var diff_subtract = (max_diff - diff) div 2; //subtracts a value which becomes greater with lower difficulty


counter = 0;
base_radius = 128 * 2;

off_platform = false;
just_off_platform = false;

walking_spd = 3;
chasing_spd = 3;//obj_game.base_spd - (max_diff - diff) + (max_diff div 2);
detect_radius = base_radius;// - ((base_radius/max_diff) * diff_subtract);
attack_radius = 96;


grv = 0.4;
spd = walking_spd;

hp = 60 + (diff * 30); //120
took_damage = false;
dmg_cooldown = 2;
dmg_flash = 3;
flash_div = 0;
dmg_timer = 0;
knockback = 0;
knockback_x = 0;
knockback_y = 0;

attack_dash = false;
attack_dir = 0;
dash_range = 8;

fatigue = 0;
fatigue_timer = 0;
fatigue_max = diff + 1; //how long it takes in seconds for fatigue to set in
fatigue_recover = max_diff - (diff - 1); //how long it takes to recover from full fatigue
fatigue_limit = fatigue_recover; //maximum speed subtracted

//wandering
dir = irandom_range(0, 359);
moveX = choose(-1, 1) * spd;
moveY = 0;

ground_spd = moveX;



knife_inst = -1;
enemy_damage = 10;//5 + (10 * diff);

damage_spd = 2; //how long to take between hits
enemy_screenshake = 4;



//drawing
enemy_sprite_array = [spr_enemy1_idle, spr_enemy1_wandering, spr_enemy1_alert, spr_enemy1_attack];
enemy_sprite_mask = spr_enemy1_mask;


enemy_sprite_weapon = spr_enemyweapon_knife;
enemy_obj_weapon = obj_enemy_knife;

cell_size = 64;
xscale = 1;
draw_frame = 0;



//other functions
event_user(1);


//always call after other functions
event_user(0);

