extends KinematicBody2D

var type:String = "interactable"
export var texture:Texture
export var txt:String
export var id:int

func _ready():
	$Sprite.texture = texture
