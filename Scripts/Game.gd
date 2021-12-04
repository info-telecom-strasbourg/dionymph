extends Node2D

var play:bool = false

func _ready():
	$AnimationPlayer.play("MenuFade")


func _on_Menu_fade_menu():
	$AnimationPlayer.play_backwards("MenuFade")
	play = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if play:
		var dia:Dialogue = preload("res://Scenes/Dialogue.tscn").instance()
		dia.num = 1
		dia.progress = 1
		add_child(dia)
		dia.connect("finished", self, "start_game")

func start_game():
	var prison = preload("res://Scenes/Prison.tscn").instance()
	add_child(prison)
