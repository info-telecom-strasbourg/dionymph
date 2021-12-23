extends Node2D

var entered = false

var prison = "res://Scenes/Prison.tscn"

func _ready():
	$YSort/Player.global_position = Global.player_pos

func _on_ToPrison_body_entered(body):
	if entered:
		Global.player_pos = global_position
		get_tree().change_scene(prison)

func _on_ToPrison_body_exited(body):
	entered = true
