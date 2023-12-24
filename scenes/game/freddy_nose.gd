extends Area

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if (event is InputEventMouseButton && event.is_pressed()):
		$sound.play();
