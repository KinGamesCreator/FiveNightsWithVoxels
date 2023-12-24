extends Button
class_name ResizeButton

var _font;
var _o_font_size;

func _ready():
	_font = get("custom_fonts/font");
	_o_font_size = _font.size;
	OnResized();
	get_viewport().connect("size_changed", self, "OnResized");

func OnResized():
	var screen_size = get_viewport_rect().size;
	var _dif_x = screen_size.x / 1920;
	var _dif_y = screen_size.y / 1080;
	_font.size = max(_dif_x,_dif_y) * _o_font_size;
