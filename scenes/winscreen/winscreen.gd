extends Control

func _ready():
	$textAnim.play("anim");
	$Timer.start();

func save_data():
	var file = File.new();
	var _json = {};
	if (file.file_exists("user://save.json")):
		file.open("user://save.json",File.READ);
		_json = JSON.parse(file.get_as_text()).result;
		file.close();
	if (!_json.has("night") || _json.night < Global.current_night): _json.night = Global.current_night;
	file.open("user://save.json",File.WRITE);
	file.store_string(to_json(_json));
	file.close();

func winTimeout():
	Global.current_night += 1;
	save_data();
	get_tree().change_scene("res://scenes/menu/menu.tscn");
