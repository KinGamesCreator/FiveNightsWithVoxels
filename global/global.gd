extends Node

var IAs_default = [0,0,0,0];
var current_night = 1;
var first_open = true;

func _input(event):
	if (event.is_action_pressed("fullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen;
