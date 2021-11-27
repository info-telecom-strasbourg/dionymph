extends Node2D

var level_node
var level:int = 1

func _ready():
	TranslationServer.set_locale("fr")

func _on_ButtonNewG_pressed():
	var dia:Dialogue = preload("res://Scenes/Dialogue.tscn").instance()
	dia.num = 1
	dia.progress = 1
	add_child(dia)
