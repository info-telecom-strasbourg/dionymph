extends Node2D

onready var game = get_node("/root/Game")

func _ready():
	pass # Replace with function body.


func _on_NextArea_body_entered(body):
	game.show_event_data(tr("ENTRER"), {"event":"change_world", "event_args":[preload("res://Maps/SecretPassagedeFin.tscn"), 4]})


func _on_NextArea_body_exited(body):
	game.hide_event_data()
