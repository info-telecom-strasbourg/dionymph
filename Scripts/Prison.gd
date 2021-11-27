extends Node2D

func _process(delta):
	$Camera2D.position = $Player.position
