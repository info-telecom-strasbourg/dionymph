extends Node2D

onready var game = get_node("/root/Game")
onready var talk_node = game.get_node("Dialogue/Talk")
onready var short_dia:Label = game.get_node("Dialogue/ShortDia")
var dont_move = false


func _input(event):
	if Input.is_action_just_released("interaction") and game.curr_NPC != -1:
		if talk_node.modulate.a == 1.0:
			talk_node.get_node("AnimationPlayer").play_backwards("TalkAnim")


func _on_Player_interact(id:int, txt:String):
	game.curr_NPC = id
	talk_node.get_node("HBox/Label").text = txt
	talk_node.get_node("AnimationPlayer").play("TalkAnim")


func _on_Player_interact_finish():
	game.curr_NPC = -1
	if talk_node.modulate.a == 1.0:
		talk_node.get_node("AnimationPlayer").play_backwards("TalkAnim")


func _on_Teleport_body_entered(body):
	body.position.x = 168
	body.position.y = 104
	short_dia.text = tr("COUCOU")
	var width:float = min(600, short_dia["custom_fonts/font"].get_string_size(tr("COUCOU")).x) + 40
	short_dia.rect_size.x = 0.0
	short_dia.rect_min_size.x = width
	short_dia.rect_position.x = (768 - width) / 2.0
	short_dia.pitches = [1.6, 1.75]#Last element is used first
	short_dia.delays = [0.2, 0.2]#Last element is used first
	var SFX_stream = preload("res://Audio/Sounds/DialogueSound.wav")
	short_dia.get_node("SFX").stream = SFX_stream
	yield(get_tree().create_timer(0.7), "timeout")
	short_dia.get_node("AnimationPlayer").play("Fade")
	short_dia.get_node("SFXTimer").start(0.0)
	short_dia.get_node("SFXTimer").connect("timeout", self, "on_timeout")

func on_timeout():
	short_dia.get_node("SFX").pitch_scale = short_dia.pitches.pop_back()
	short_dia.get_node("SFX").volume_db = linear2db(range_lerp(short_dia.get_node("SFX").pitch_scale, 0, 10, 1, 0)) + 1.0
	short_dia.get_node("SFX").play()
	if len(short_dia.pitches) > 0:
		short_dia.get_node("SFXTimer").start(short_dia.delays.pop_back())
	else:
		short_dia.get_node("SFXTimer").stop()
		yield(get_tree().create_timer(2.0), "timeout")
		short_dia.get_node("AnimationPlayer").play_backwards("Fade")

func teleport_player_back():
	$Teleport.monitoring = false
	$Player.position = Vector2(176, 328)
