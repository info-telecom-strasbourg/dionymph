extends Node2D

signal level_complete

func _ready():
	$Player.spawn = Vector2(56, 288)

func _physics_process(delta):
	$Block.rotation_degrees -= 2.5
