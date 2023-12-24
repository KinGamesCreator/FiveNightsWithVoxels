extends Control

var current_night = 1;

var night_levels = [[1,1,0,0],[3,1,1,0],[0,5,2,1],[2,4,6,2],[5,7,5,3],[10,12,16,4]];

"""INIT"""
func _ready():
	reset_menu();
	$initial/menu_cinematic/AnimationPlayer.play("estatica");

"""RESTART MENU"""
func reset_menu():
	load_data();
	refresh_buttons();
	for i in get_children():
		i.visible = false;
	$initial.visible = true;

"""LOAD AND SAVE GAME DATA"""
func load_data():
	var _json = {};
	var file = File.new();
	if (file.file_exists("user://save.json")):
		file.open("user://save.json",File.READ);
		_json = JSON.parse(file.get_as_text()).result;
		file.close();
	if (_json.has("night")): current_night = _json.night;
	else: current_night = 1;

"""RESET INITIAL MENU BUTTONS"""
func refresh_buttons():
	$initial/btn_continue.disabled = false;
	$initial/btn_extra_night.disabled = false;
	$initial/btn_custom_night.disabled = false;
	
	$initial/btn_continue/Label.text = "Night " + str(min(5,current_night));
	if (current_night == 1): $initial/btn_continue.disabled = true;
	if (current_night < 6): $initial/btn_extra_night.disabled = true;
	if (current_night < 7): $initial/btn_custom_night.disabled = true;

"""NEW GAME"""
func new_game():
	current_night = 1;
	Global.current_night = 1;
	Global.IAs_default = night_levels[0];
	game_ready();
"""CONTINUE"""
func continue_game():
	current_night = min (current_night,5);
	Global.current_night = current_night;
	Global.IAs_default = night_levels[current_night-1];
	game_ready();
"""SIX NIGHT"""
func six_night():
	current_night = 6;
	Global.current_night = current_night;
	Global.IAs_default = night_levels[current_night-1];
	game_ready();
"""CUSTOM NIGHT"""
func custom_night():
	$initial.visible = false;
	$customNight.visible = true;
"""START NIGHT"""
func game_ready():
	for i in get_children():
		i.visible = false;
	$nightNumber/ResizeLabel.text = "Night " + str(Global.current_night);
	$nightNumber.visible = true;
	$nightNumber/Timer.start();
	
func intro_timeout():
	get_tree().change_scene("res://scenes/game/game.tscn");

func static_anim_finish(anim_name):
	if (anim_name != "estatica" || Global.first_open):
		Global.first_open = false;
		return;
