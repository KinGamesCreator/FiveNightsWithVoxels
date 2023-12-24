extends TextureButton

onready var game = get_tree().current_scene;
var random : RandomNumberGenerator = RandomNumberGenerator.new();

func _ready(): random.randomize();

func _pressed():
	get_parent().get_node("Cameras").visible = !get_parent().get_node("Cameras").visible;
	if (!get_parent().get_node("Cameras").visible):
		game.get_node("Player").current = true;
	else:
		game.lights[0] = false;
		game.lights[1] = false;
		game.get_node("sounds/camera_change").play();
		get_parent().get_parent().get_node("IAs/Foxy/blockTimer").start(random.randf_range(0.0,17.0));
		game.get_node("Control/Cameras/cam_change").play("change");
		if (game.current_cam != ""): game.get_node("cameras").get_node(game.current_cam).current = true;
		else: game.get_node("cameras/1A").current = true;
	visible = false;
	game.get_node("Control/show_open_cams").start();
