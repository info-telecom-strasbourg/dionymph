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


func _on_ButtonNewG_mouse_entered():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($ButtonNewG.material, "shader_param/strength", null, 1.0, 0.5)
	tween.start()
	yield(tween, "tween_all_completed")
	remove_child(tween)
	tween.queue_free()


func _on_ButtonNewG_mouse_exited():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($ButtonNewG.material, "shader_param/strength", null, 0.0, 0.2)
	tween.start()
	yield(tween, "tween_all_completed")
	remove_child(tween)
	tween.queue_free()
