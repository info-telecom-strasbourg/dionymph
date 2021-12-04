extends Control

var tween:Tween
var closing:bool = false

func _ready():
	rect_scale *= 0.85
	rect_pivot_offset = Vector2(384, 240)
	rect_position = Vector2(0, 30)
	modulate.a = 0
	tween = Tween.new()
	add_child(tween)
	tween.connect("tween_all_completed", self, "on_tween_complete")

func open_panel():
	visible = true
	closing = false
	tween.interpolate_property(self, "modulate", null, Color.white, 0.15)
	tween.interpolate_property(self, "rect_position", null, Vector2(0, 20), 0.15)
	tween.start()

func close_panel():
	if not tween.is_active():
		tween.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 0.15)
		tween.interpolate_property(self, "rect_position", null, Vector2(0, 30), 0.15)
		tween.start()
		closing = true

func on_tween_complete():
	if closing:
		visible = false
