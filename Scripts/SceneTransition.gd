extends ColorRect

signal on_fade_out_finished
signal on_fade_in_finished

func fade(speed:float = 1.0):
	$AnimationPlayer.play("FadeIn", -1, speed)
	yield($AnimationPlayer, "animation_finished")
	emit_signal("on_fade_in_finished")
	$AnimationPlayer.play("FadeIn", -1, -speed, true)
	yield($AnimationPlayer, "animation_finished")
	emit_signal("on_fade_out_finished")
