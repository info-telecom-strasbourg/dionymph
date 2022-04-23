extends Area2D

onready var game = get_node("/root/Game")
export var contents:Array = []

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coffre_body_entered(body):
	game.show_event_data(tr("OUVRIR"), {"event":"open_chest", "contents":contents})


func _on_Coffre_body_exited(body):
	game.hide_event_data()
