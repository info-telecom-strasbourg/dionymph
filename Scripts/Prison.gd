extends Node2D

func _process(delta):
	$Camera2D.position = $Player.position

var entered = false

var world = "res://Scenes/World.tscn"

func _on_ToWorld_body_entered(body):
	if entered:
		#Global.player_pos = global_position
		get_tree().change_scene(world)

func _on_ToWorld_body_exited(body):
	entered = true
