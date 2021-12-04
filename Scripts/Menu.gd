extends Node2D

signal fade_menu

var level_node
var level:int = 1
var settings_panel = preload("res://Scenes/Settings.tscn").instance()

func _ready():
	TranslationServer.set_locale("fr")
	settings_panel.visible = false
	$Panels.add_child(settings_panel)

func _on_ButtonNewG_pressed():
	emit_signal("fade_menu")


func _on_ButtonPar_pressed():
	if settings_panel.visible:
		settings_panel.close_panel()
	else:
		settings_panel.open_panel()
