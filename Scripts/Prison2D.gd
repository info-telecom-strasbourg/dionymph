extends Node2D

var sceneFader
var curr_NPC:int = -1

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

func _input(event):
	if Input.is_action_just_released("interaction") and curr_NPC != -1:
		var dia:Dialogue = preload("res://Scenes/Dialogue.tscn").instance()
		dia.world = 0
		dia.num = curr_NPC
		add_child(dia)
		dia.connect("finished", self, "start_game")
		print("A")
