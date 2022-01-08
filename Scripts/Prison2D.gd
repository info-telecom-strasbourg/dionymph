extends Node2D

var sceneFader

func _ready():
	sceneFader = find_node("ColorRect")

var entered = true

### Changement de scène vers World
var world = "res://Scenes/World.tscn"

func _on_ToWorld_body_entered(body):
	if entered:
		#Global.player_pos = global_position
		sceneFader.fade_out()
		yield(sceneFader, "finished")
		Global.change_scene(world)

func _on_ToWorld_body_exited(body):
	entered = true
