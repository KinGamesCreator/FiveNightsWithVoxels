extends Area

export(String,"L_Door","R_Door","L_Light","R_Light") var type = "L_Door";
onready var game = get_tree().current_scene;

func _process(_delta):
	match(type):
		"L_Door":
			if (game.doors[0] == "open"): get_parent().get_active_material(0).albedo_color = Color(100.0/255.0,0,0,1);
			else: get_parent().get_active_material(0).albedo_color = Color(180.0/255.0,66.0/255.0,66.0/255.0,1);
		"R_Door":
			if (game.doors[1] == "open"): get_parent().get_active_material(0).albedo_color = Color(100.0/255.0,0,0,1);
			else: get_parent().get_active_material(0).albedo_color = Color(180.0/255.0,66.0/255.0,66.0/255.0,1);
		"L_Light":
			if (game.lights[0]): get_parent().get_active_material(0).albedo_color = Color(144.0/255.0,144.0/255.0,144.0/255.0,1);
			else: get_parent().get_active_material(0).albedo_color = Color(78.0/255.0,78.0/255.0,78.0/255.0,1);
		"R_Light":
			if (game.lights[1]): get_parent().get_active_material(0).albedo_color = Color(144.0/255.0,144.0/255.0,144.0/255.0,1);
			else: get_parent().get_active_material(0).albedo_color = Color(78.0/255.0,78.0/255.0,78.0/255.0,1);



func _input_event(_camera, event, _position, _normal, _shape_idx):
	if (event is InputEventMouseButton && event.is_pressed()):
		if (game.battery == 0):
			if (!game.get_node("sounds/errorSound").is_playing()): game.get_node("sounds/errorSound").play();
			return;
		match(type):
			"L_Door":
				if (!game.get_node("sounds/leftDoor").playing):
					if (game.doors[0] == "open"): game.doors[0] = "close";
					else: game.doors[0] = "open";
			"R_Door":
				if (!game.get_node("sounds/rightDoor").playing):
					if (game.doors[1] == "open"): game.doors[1] = "close";
					else: game.doors[1] = "open";
			"L_Light":
				game.lights[0] = !game.lights[0];
				game.lights[1] = false;
				if (game.lights[0] && game.bonnie_pos == "LD" && !game.get_node("IAs/Bonnie").sound_surprise):
					game.get_node("IAs/Bonnie").sound_surprise = true;
					game.get_node("sounds/surprise").play();
			"R_Light":
				game.lights[1] = !game.lights[1];
				game.lights[0] = false;
				if (game.lights[1] && game.chica_pos == "RD" && !game.get_node("IAs/Chica").sound_surprise):
					game.get_node("IAs/Chica").sound_surprise = true;
					game.get_node("sounds/surprise").play();
