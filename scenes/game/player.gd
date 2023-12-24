extends Camera

export var rotationZ : float = 0;

var status = 0.0;
var anim_status = 0.0;

func _process(_delta):
	
	status = float(floor(float(get_viewport().get_mouse_position().x) / float(get_viewport().size.x/3)))-1;
	rotation_degrees.z = rotationZ;
	status = clamp(status,-1.0,1.0);
	
	if (anim_status != status):
		anim_status = lerp(anim_status,status,0.2);
		if (abs(anim_status - status) < 0.005): anim_status = status;
		global_rotation.y = deg2rad(180.0 - (anim_status * 50.0));
	
