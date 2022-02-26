extends Node2D

onready var game = get_node("/root/Game")
onready var talk_node = game.get_node("Dialogue/Talk")
var dont_move = false


func _input(event):
	if Input.is_action_just_released("interaction") and game.curr_NPC != -1:
		if talk_node.modulate.a == 1.0:
			talk_node.get_node("AnimationPlayer").play_backwards("TalkAnim")


func _on_Player_interact(id:int, txt:String):
	game.curr_NPC = id
	talk_node.get_node("HBox/Label").text = txt
	talk_node.get_node("AnimationPlayer").play("TalkAnim")


func _on_Player_interact_finish():
	game.curr_NPC = -1
	if talk_node.modulate.a == 1.0:
		talk_node.get_node("AnimationPlayer").play_backwards("TalkAnim")
