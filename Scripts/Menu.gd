extends Node2D

signal fade_menu

var level_node
var level:int = 1

func _ready():
	TranslationServer.set_locale("fr")

func _on_ButtonNewG_pressed():
	emit_signal("fade_menu")
