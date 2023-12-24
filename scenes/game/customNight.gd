extends Panel

var bonnieIA = 2;
var chicaIA = 2;
var foxyIA = 2;
var freddyIA = 2;

func _ready():
	set_images();

func set_images():
	$bonnie/ColorRect/ColorRect/TextureRect.texture.current_frame = clamp(bonnieIA,0,18);
	$chica/ColorRect/ColorRect/TextureRect.texture.current_frame = clamp(chicaIA,0,18);
	$foxy/ColorRect/ColorRect/TextureRect.texture.current_frame = clamp(foxyIA,0,18);
	$freddy/ColorRect/ColorRect/TextureRect.texture.current_frame = clamp(freddyIA,0,18);
	$bonnie_text.text = "IA: " + str(bonnieIA);
	$chica_text.text = "IA: " + str(chicaIA);
	$foxy_text.text = "IA: " + str(foxyIA);
	$freddy_text.text = "IA: " + str(freddyIA);

func bonnie_sum():
	bonnieIA = clamp(bonnieIA + 1, 0, 20);
	set_images();
func bonnie_rest():
	bonnieIA = clamp(bonnieIA - 1, 0, 20);
	set_images();

func chica_sum():
	chicaIA = clamp(chicaIA + 1, 0, 20);
	set_images();
func chica_rest():
	chicaIA = clamp(chicaIA - 1, 0, 20);
	set_images();

func foxy_sum():
	foxyIA = clamp(foxyIA + 1, 0, 20);
	set_images();
func foxy_rest():
	foxyIA = clamp(foxyIA - 1, 0, 20);
	set_images();

func freddy_sum():
	freddyIA = clamp(freddyIA + 1, 0, 20);
	set_images();
func freddy_rest():
	freddyIA = clamp(freddyIA - 1, 0, 20);
	set_images();

func returnButton():
	visible = false;
	get_parent().get_node("initial").visible = true;

func startNight():
	Global.IAs_default = [ bonnieIA, chicaIA, foxyIA, freddyIA ];
	Global.current_night = 7;
	get_parent().game_ready();
