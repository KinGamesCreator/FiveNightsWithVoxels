extends TextureButton

export(String,"1A","1B","1C","2A","2B","3","4A","4B","5","6","7") var type = "1A";
onready var game = get_tree().current_scene;

func _process(_delta):
	pressed = (game.current_cam == type);

func _pressed():
	if (game.current_cam != type):
		game.get_node("cameras").get_node(type).current = true;
		game.get_node("Control/Cameras/cam_change").play("change");
		game.current_cam = type;
		game.get_node("sounds/camera_change").play();
