extends Node

onready var game = get_tree().current_scene;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var rooms = {
	"1A" : ["1B","5"],
	"5" : ["1B","2A"],
	"1B" : ["5","2A"],
	"2A" : ["3","2B"],
	"3" : ["2A","2B"],
	"2B" : ["LD","2A","3"],
	"LD" : ["1B","OF"],
	"OF" : ["OF"]
}
var sound_surprise = false;

func _ready(): random.randomize();

func move():
	if (game.bonnie_pos == "OF"): return;
	var _num = random.randi_range(1,20);
	if (_num <= game.IA_bonnie):
		sound_surprise = false;
		if (game.bonnie_pos == "LD"):
			if (game.doors[0] == "open"):
				game.show_jumpscare("bonnie");
				game.bonnie_pos = "OF";
			else:
				game.bonnie_pos = "1B";
				if (game.current_cam == "1B"): game.get_node("Control/Cameras/cam_change").play("change");
		else:
			var _pos = random.randi_range(0,rooms[game.bonnie_pos].size()-1);
			if (game.current_cam == game.bonnie_pos || game.current_cam == rooms[game.bonnie_pos][_pos]):
				game.get_node("Control/Cameras/cam_change").play("change");
			if (game.bonnie_pos == "LD" || rooms[game.bonnie_pos][_pos] == "LD"): game.lights[0] = false;
			game.bonnie_pos = rooms[game.bonnie_pos][_pos];
