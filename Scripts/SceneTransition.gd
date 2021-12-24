extends ColorRect

signal finished

func fade_out():
	$AnimationPlayer.play_backwards("FadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("finished")
