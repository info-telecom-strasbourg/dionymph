extends Node2D

# On ne veut pas que le joueur sorte tt de suite de la maison
var entered = false

var outside = "res://Scenes/World.tscn"

func _on_Exit_body_entered(body):
	if entered:
		get_tree().change_scene(outside)

func _on_Exit_body_exited(body):
	entered = true
