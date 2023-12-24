extends Button

func _pressed():
	get_parent().get_parent().get_node("cameras").get_node(text).current = true;
	
