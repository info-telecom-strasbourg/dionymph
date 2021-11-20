tool
extends RichTextEffect
class_name TextFade

var bbcode = "textFade"

func _process_custom_fx(char_fx):
	char_fx.color = Color(1.0, 1.0, 1.0, clamp(char_fx.elapsed_time * 5.0 - char_fx.absolute_index / 15.0, 0.0, 1.0))
	char_fx.offset.y = -pow(1.0 - char_fx.color.a, 2.0) * 2.0
	return true
