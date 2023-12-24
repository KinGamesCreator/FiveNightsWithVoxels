extends Node

onready var game = get_tree().current_scene;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var rooms = {
	"1A" : ["1B","7"],
	"7" : ["6","1B","4A"],
	"6" : ["7","4A"],
	"1B" : ["4A","7"],
	"4A" : ["4B","6"],
	"4B" : ["RD","4A","6"],
	"RD" : ["1B","OF"],
	"OF" : ["OF"]
}
var sound_surprise = false;

func _ready(): random.randomize();

func move():
	if (game.chica_pos == "OF"): return;
	var _num = random.randi_range(1,20);
	if (_num <= game.IA_chica):
		sound_surprise = false;
		if (game.chica_pos == "RD"):
			if (game.doors[1] == "open"):
				game.show_jumpscare("chica");
				game.chica_pos = "OF";
			else:
				game.chica_pos = "1B";
				if (game.current_cam == "1B"): game.get_node("Control/Cameras/cam_change").play("change");
		else:
			var _pos = random.randi_range(0,rooms[game.chica_pos].size()-1);
			if (game.current_cam == game.chica_pos || game.current_cam == rooms[game.chica_pos][_pos]):
				game.get_node("Control/Cameras/cam_change").play("change");
			if (game.chica_pos == "RD" || rooms[game.chica_pos][_pos] == "RD"): game.lights[1] = false;
			game.chica_pos = rooms[game.chica_pos][_pos];
