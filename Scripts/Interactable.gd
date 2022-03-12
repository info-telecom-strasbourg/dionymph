tool
extends KinematicBody2D

export var type:String = "interactable"
export var texture:Texture
export var txt:String
export var event:String
export var event_args:Array

func _ready():
	$Sprite.texture = texture
