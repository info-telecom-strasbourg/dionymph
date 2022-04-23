extends Node2D

var entered = false
var sceneFader = find_node("ColorRect")
var prison = "res://Maps/Prison.tscn"

func _ready():
	sceneFader = find_node("ColorRect")
	$YSort/Player.global_position = Global.player_pos

func _on_ToPrison_body_entered(body):
	if entered:
		Global.player_pos = global_position
		sceneFader.fade_out()
		yield(sceneFader, "finished")
		Global.change_scene(prison)

func _on_ToPrison_body_exited(body):
	entered = true
