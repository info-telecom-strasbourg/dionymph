extends Node2D

onready var game = get_node("/root/Game")
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

func _input(event):
	if Input.is_action_just_released("interaction") and game.curr_NPC != -1:
		if $CanvasLayer/Talk.modulate.a == 1.0:
			$CanvasLayer/Talk/AnimationPlayer.play_backwards("TalkAnim")


func _on_Player_interact(id:int, txt:String):
	game.curr_NPC = id
	$CanvasLayer/Talk/HBox/Label.text = txt
	$CanvasLayer/Talk/AnimationPlayer.play("TalkAnim")


func _on_Player_interact_finish():
	game.curr_NPC = -1
	if $CanvasLayer/Talk.modulate.a == 1.0:
		$CanvasLayer/Talk/AnimationPlayer.play_backwards("TalkAnim")
