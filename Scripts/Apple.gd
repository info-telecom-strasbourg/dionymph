extends Area2D
class_name Fruit

export var type:int = 0
enum Fruit {RED_APPLE, GREEN_APPLE, YELLOW_APPLE, ORANGE}

onready var player = get_node("../Player")
onready var level = get_parent()
onready var menu = get_node("/root/Menu")

func _ready():
	if type == Fruit.RED_APPLE:
		$Sprite.texture = load("res://Graphics/RedApple.png")
	elif type == Fruit.GREEN_APPLE:
		$Sprite.texture = load("res://Graphics/GreenApple.png")
	elif type == Fruit.YELLOW_APPLE:
		$Sprite.texture = load("res://Graphics/YellowApple.png")
	elif type == Fruit.ORANGE:
		$Sprite.texture = load("res://Graphics/Orange.png")

func _on_Area2D_body_entered(_body):
	if visible:
		visible = false
		if type == Fruit.RED_APPLE:
			player.score += 100
			level.get_node("Score").text = String(player.score)
		elif type == Fruit.GREEN_APPLE:
			player.air_jump = true
		elif type == Fruit.YELLOW_APPLE:
			player.score += 200
			level.get_node("Score").text = String(player.score)
		elif type == Fruit.ORANGE:
			menu.get_node("Blur/Blur").visible = true
			menu.get_node("Panels/WinPanel").visible = true
			menu.get_node("Panels/WinPanel/Score").text = String(player.score)
			menu.get_node("Panels/WinPanel/Deaths").text = "Deaths: %s" % player.deaths
