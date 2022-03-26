extends Node2D

onready var game = get_node("/root/Game")
onready var talk_node = game.get_node("Dialogue/Talk")
var sceneFader

func _ready():
	sceneFader = find_node("ColorRect")

var dont_move:bool = false

### Changement de scène vers World
var world = "res://Scenes/World.tscn"

func _on_ToWorld_body_entered(body):
	game.show_event_data(tr("MONTER"), {"event":"afficher_chateau"})

func _on_ToWorld_body_exited(body):
	game.hide_event_data()
