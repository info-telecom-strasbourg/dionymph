extends KinematicBody2D

onready var game = get_node("/root/Game")
export var id:int
export var NPC_name:String

func _ready():
	pass

func _on_InteractArea_body_entered(body):
	if body is Player:
		game.curr_NPC = id
