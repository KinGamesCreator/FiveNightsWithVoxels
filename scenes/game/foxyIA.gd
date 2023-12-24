extends Node

onready var game = get_tree().current_scene;
var random : RandomNumberGenerator = RandomNumberGenerator.new();
var running = false;

func _ready(): random.randomize();

func _process(_delta):
	if (game.foxy_pos == 3 && game.get_node("cameras/2A").current && !running):
		game.get_node("Control/Cameras/cam_change").play("change");
		game.get_node("cameras/foxy_run/map_run").play("run");
		running = true;

func move():
	if (!game.get_node("Player").current): return;
	if ($blockTimer.get_time_left() != 0): return;
	
	if (game.foxy_pos == 3): return;
	var _num = random.randi_range(1,20);
	if (_num <= game.IA_foxy):
		game.foxy_pos = min(game.foxy_pos+1,3);
		if (game.current_cam == "1C" || (game.current_cam == "2A" && game.foxy_pos == 3)):
			game.get_node("Control/Cameras/cam_change").play("change");
			$runTimer.stop();
	
	match(game.foxy_pos):
		0:
			game.get_node("cameras/foxy-1").visible = false;
			game.get_node("cameras/foxy-2").visible = false;
			game.get_node("cameras/cortinas-1").visible = true;
			game.get_node("cameras/cortinas-2").visible = false;
		1:
			game.get_node("cameras/foxy-1").visible = true;
			game.get_node("cameras/foxy-2").visible = false;
			game.get_node("cameras/cortinas-1").visible = false;
			game.get_node("cameras/cortinas-2").visible = true;
		2:
			game.get_node("cameras/foxy-1").visible = false;
			game.get_node("cameras/foxy-2").visible = true;
			game.get_node("cameras/cortinas-1").visible = false;
			game.get_node("cameras/cortinas-2").visible = true;
		3:
			game.get_node("cameras/foxy-1").visible = false;
			game.get_node("cameras/foxy-2").visible = false;
			game.get_node("cameras/cortinas-1").visible = false;
			game.get_node("cameras/cortinas-2").visible = true;
			$runTimer.start();

func _finish_run(_anim_name):
	if (_anim_name != "run"): return;
	game.get_node("cameras/foxy_run/map_run").play("RESET");
	$runTimer.stop();
	if (game.doors[0] == "close"):
		running = false;
		game.foxy_pos = 1;
		game.get_node("cameras/foxy-1").visible = true;
		game.get_node("cameras/foxy-2").visible = false;
		game.get_node("cameras/cortinas-1").visible = false;
		game.get_node("cameras/cortinas-2").visible = true;
		game.get_node("sounds/foxyDoor").play();
		$Timer.start(5);
	else:
		game.show_jumpscare("foxy");
		running = false;


func _runTimer():
	if (!running):
		game.get_node("cameras/foxy_run/map_run").play("run");
		running = true;
