extends Node2D

export (PackedScene) var inside_house

func _on_DoorWay_body_entered(body):
	body.house = self

func _on_DoorWay_body_exited(body):
	body.house = null

func enter():
	get_tree().change_scene(inside_house.resource_path)
