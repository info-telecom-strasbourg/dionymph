extends Node2D

var sceneFader

func _ready():
	sceneFader = find_node("ColorRect")

func _process(delta):
	$Camera2D.position = $Player.position

var entered = false


### Changement de scène vers World
var world = "res://Scenes/World.tscn"

func _on_ToWorld_body_entered(body):
	if entered:
		#Global.player_pos = global_position
		sceneFader.fade_out()
		yield(sceneFader, "finished")
		Global.change_scene(world)


### Arrivée de World
func _on_ToWorld_body_exited(body):
	entered = true
