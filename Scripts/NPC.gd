extends KinematicBody2D

onready var game = get_node("/root/Game")
var type:String = "NPC"
export var id:int
export var NPC_texture:Texture
#export var NPC_name:String

func _ready():
	$Sprite.texture = NPC_texture
