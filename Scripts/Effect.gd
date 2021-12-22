extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0 #Peut être enlevé puisqu'il n'y a plus le playing de checked
	play("Animate")

func _on_animation_finished():
	queue_free()
