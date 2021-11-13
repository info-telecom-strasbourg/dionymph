extends Node2D

var level_node
var level:int = 1
var level_select_button_scene = preload("res://Scenes/LevelSelectButton.tscn")

func _ready():
	for i in 15:
		var btn = level_select_button_scene.instance()
		$Panels/LevelSelect/GridContainer.add_child(btn)
		btn.text = String(i + 1)
		btn.connect("pressed", self, "on_lv_pressed", [i + 1])

func on_lv_pressed(lv:int):
	$Button.visible = false
	$Background.visible = false
	$Title.visible = false
	$Panels/LevelSelect.visible = false
	level = lv
	put_level()

func on_level_complete():
	$Panels/WinPanel.visible = true
	$Blur/Blur.visible = true

func show_menu():
	$Button.visible = true
	$Background.visible = true
	$Title.visible = true
	


func _on_Button_pressed():
	$Panels/LevelSelect.visible = true
	$Title.visible = false

func put_level():
	level_node = load("res://Scenes/Level%s.tscn" % level).instance()
	add_child(level_node)
	level_node.connect("level_complete", self, "on_level_complete")

func _on_Retry_pressed():
	$Panels/WinPanel.visible = false
	$Blur/Blur.visible = false
	level_node.get_node("Player").reset_map()


func _on_Menu_pressed():
	remove_child(level_node)
	show_menu()


func _on_Next_pressed():
	level += 1
	$Panels/WinPanel.visible = false
	$Blur/Blur.visible = false
	remove_child(level_node)
	level_node.queue_free()
	put_level()
