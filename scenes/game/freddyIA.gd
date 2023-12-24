extends Node


onready var game = get_tree().current_scene;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var rooms = {
	"1A" : ["1B"],
	"1B" : ["7"],
	"7" : ["6"],
	"6" : ["4A"],
	"4A" : ["4B"],
	"4B" : ["1B","OF"],
	"OF" : ["OF"]
}

func _ready(): random.randomize();

func move():
	if (game.bonnie_pos == "1A" || game.chica_pos == "1A"): return;
	if (!game.get_node("Player").current): return;
	if (game.freddy_pos == "OF"): return;
	var _num = random.randi_range(1,20);
	if (_num <= game.IA_freddy):
		if (game.freddy_pos == "4B"):
			if (game.doors[1] == "open"):
				game.show_jumpscare("freddy");
				game.freddy_pos = "OF";
			else:
				game.freddy_pos = "1A";
				if (game.current_cam == "1A"): game.get_node("Control/Cameras/cam_change").play("change");
		else:
			var _pos = random.randi_range(0,rooms[game.freddy_pos].size()-1);
			if (game.current_cam == game.freddy_pos || game.current_cam == rooms[game.freddy_pos][_pos]):
				game.get_node("Control/Cameras/cam_change").play("change");
			game.freddy_pos = rooms[game.freddy_pos][_pos];

