extends Node2D

onready var game = get_node("/root/Game")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NextArea_body_entered(body):
		game.show_event_data(tr("ENTRER"), {"event":"change_world", "event_args":[preload("res://Maps/Arcknot/Ville_part1.tscn"), 2]})
