extends Node2D

signal fade_menu

var level_node
var level:int = 1
var settings_panel = preload("res://Scenes/Settings.tscn").instance()

func _ready():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("MenuAnim", -1, 0.5)
	settings_panel.visible = false
	$Panels.add_child(settings_panel)
	#Check whether there is a save
	var file = Directory.new()
	$ButtonCharger.visible = file.file_exists("user://Save1.sav") or file.file_exists("user://Save2.sav") or file.file_exists("user://Save3.sav")

func _on_ButtonNewG_pressed():
	emit_signal("fade_menu")


func _on_ButtonPar_pressed():
	if settings_panel.visible:
		settings_panel.close_panel()
	else:
		settings_panel.open_panel()

func _process(delta):
	for cloud in $Clouds.get_children():
		cloud.position.x -= 1.0
		if cloud.position.x < -200:
			cloud.position.x = 1000
