extends Spatial

"""DEFAULT VALUES"""
var doors = ["open","open"];
var lights = [false,false];

var bonnie_pos = "1A";
var chica_pos = "1A";
var freddy_pos = "1A";
var foxy_pos = 0;

var IA_bonnie = 0; #+1 2AM, 3AM & 4AM
var IA_chica = 0; #+1 3AM & 4AM
var IA_freddy = 0; #NO AUMENTA
var IA_foxy = 0;

var current_cam = "1A";
var current_hour = 0;
var hour_text = "12 AM";
var battery = 100.0;

var random : RandomNumberGenerator = RandomNumberGenerator.new();

onready var doors_playback = [
	$leftDoor/AnimationTree.get("parameters/playback"),
	$rightDoor/AnimationTree.get("parameters/playback")
]

"""INIT"""
func _ready():
	"""PREPARE GAME"""
	random.randomize();
	$animations/anim_lights.play("titilear");
	$cameras/foxy_run/AnimationPlayer.play("run");
	$cameras/foxy_run/map_run.play("RESET");
	$"cameras/foxy-1".visible = false;
	$"cameras/foxy-2".visible = false;
	$"cameras/cortinas-1".visible = true;
	$"cameras/cortinas-2".visible = false;
	$Control/hourLabel/nightLabel.text = "Night " + str(Global.current_night);
	$Control/hourLabel.text = hour_text;
	doors_playback[0].start("open"); doors_playback[1].start("open");
	IA_bonnie = Global.IAs_default[0]; IA_chica = Global.IAs_default[1];
	IA_freddy = Global.IAs_default[3]; IA_foxy = Global.IAs_default[2];
	if (Global.IAs_default[0] == 1 && Global.IAs_default[1] == 9 && Global.IAs_default[2] == 8 && Global.IAs_default[3] == 7):
		$deadTimer.start(20);
		$IAs/Bonnie/Timer.stop();
		$IAs/Foxy/Timer.stop();
		$IAs/Foxy/runTimer.stop();
		$IAs/Chica/Timer.stop();
		$IAs/Freddy/Timer.stop();
		$laughTimer.stop();
		bonnie_pos = "OF";
		chica_pos = "OF";
		freddy_pos = "OF";

"""STOP GAME"""
func stop_game():
	$hourTimer.stop();
	$IAs/Bonnie/Timer.stop();
	$IAs/Foxy/Timer.stop();
	$IAs/Foxy/runTimer.stop();
	$IAs/Chica/Timer.stop();
	$IAs/Freddy/Timer.stop();
	$laughTimer.stop();
	$energyTimer.stop();
	$deadTimer.stop();

func _process(_delta):
	"""LIGHTS AND CAMERAS"""
	if (doors_playback[0].get_current_node() != doors[0]):
		doors_playback[0].travel(doors[0]);
		$sounds/leftDoor.play();
	if (doors_playback[1].get_current_node() != doors[1]):
		doors_playback[1].travel(doors[1]);
		$sounds/rightDoor.play();
	$leftLight.get_active_material(0).flags_transparent = lights[0];
	$rightLight.get_active_material(0).flags_transparent = lights[1];
	
	"""ANIMATRONICS VISIBILITY"""
	if (!$Player.current):
		$"cameras/chica-cameras".visible = (chica_pos != "RD" && chica_pos != "OF" && $cameras.get_node(chica_pos).current);
		$"cameras/bonnie-cameras".visible = (bonnie_pos != "LD" && bonnie_pos != "OF" && $cameras.get_node(bonnie_pos).current);
		$"cameras/freddy-cameras".visible = (freddy_pos != "OF" && $cameras.get_node(freddy_pos).current);
	else:
		$Animatronics/bonnie.visible = (bonnie_pos == "LD");
		$Animatronics/chica.visible = (chica_pos == "RD");
	
	$oficina.visible = $Player.current;
	$cameras/cameras_map.visible = !$Player.current;
	
	"""SOUNDS"""
	if ($sounds/office_ambience.playing != (battery > 0)): $sounds/office_ambience.playing = (battery > 0);
	if ($sounds/leftLight.playing != lights[0]): $sounds/leftLight.playing = lights[0];
	if ($sounds/rightLight.playing != lights[1]): $sounds/rightLight.playing = lights[1];
	if ($sounds/camera_static.playing != $Control/Cameras.visible): $sounds/camera_static.playing = $Control/Cameras.visible;
	if ($sounds/kitchen.playing != (chica_pos == "6" || freddy_pos == "6")): $sounds/kitchen.playing = (chica_pos == "6" || freddy_pos == "6");
	
	"""BATTERY_CALCULATION"""
	$Control/battery_graphic.texture.current_frame = int(doors[0] == "close") + int(doors[1] == "close") + int(lights[0]) + int(lights[1]) + int(!$Player.current);

func show_jumpscare(type : String):
	$Control/openCams.visible = false; $Control/show_open_cams.stop();
	$Player/AnimationPlayer.play("jumpscare"); $Player.current = true;
	$Control/Cameras.visible = false;
	$Control/Viewport/animations.visible = true;
	$Control/Viewport/animations.play(type); $Control/jumpscare.visible = true;
	stop_game();
	$Control/jumpscare/sound.play();

"""CAMERAS ANIMATION"""
var cam_move_flag = true;
func _on_move_cam_timer_timeout():
	if (cam_move_flag): $cameras/cam_move.play("move");
	else: $cameras/cam_move.play_backwards("move");
	cam_move_flag = !cam_move_flag;
func _on_show_open_cams_timeout(): $Control/openCams.visible = true;

"""LOOSE"""
func _on_jumpscare_end(): get_tree().change_scene("res://scenes/menu/menu.tscn");

func new_hour():
	current_hour += 1;
	hour_text = str(current_hour) + " AM";
	if (current_hour == 2 || current_hour == 3 || current_hour == 4): IA_bonnie += 1;
	if (current_hour == 3 || current_hour == 4):
		IA_chica += 1;
		IA_foxy += 1;
	if (current_hour == 6):
		stop_game();
		get_tree().change_scene("res://scenes/winscreen/winscreen.tscn");
	$Control/hourLabel.text = hour_text;

func laugh_timeout():
	var _num = random.randi_range(1,10);
	if (_num <= 2):
		$sounds/laughs.play();

func energy_cost():
	battery -= (9.0/140.0) * float($Control/battery_graphic.texture.current_frame+1);
	battery = max(battery,0);
	if (battery == 0):
		$energyTimer.stop();
		$IAs/Bonnie/Timer.stop();
		$IAs/Foxy/Timer.stop();
		$IAs/Foxy/runTimer.stop();
		$IAs/Chica/Timer.stop();
		$IAs/Freddy/Timer.stop();
		$laughTimer.stop();
		doors = ["open","open"];
		lights = [false,false];
		$deadTimer.start(random.randi_range(10,15));
		$Control/openCams.visible = false;
		$Control/show_open_cams.stop();
		$Player.current = true;
		$Control/Cameras.visible = false;
		$sounds/powerDown.play();
	$Control/powerLeft.text = "Power left: " + str(round(battery)) + "%";

func dead_energy(): show_jumpscare("freddy");
