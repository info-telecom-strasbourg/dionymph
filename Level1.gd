extends Node2D
signal level_complete

func _ready():
	$Player.spawn = Vector2(58, 118)



func _on_HSlider_value_changed(value):
	$Player.JUMP_INITIAL_STRENGTH = value
	prints("jump strength", value)

func _on_HSlider2_value_changed(value):
	$Player.GRAVITY = value
	prints("gravity", value)

func _on_HSlider3_value_changed(value):
	$Player.MOVE_SPEED = value
	prints("move speed", value)
