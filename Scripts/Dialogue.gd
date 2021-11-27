class_name Dialogue
extends Control

signal finished
signal button_clicked

var num:int
var progress:int
onready var RTL:RichTextLabel = $Panel/HBox/RichTextLabel

func _ready():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("FadeIn")
	RTL.visible_characters = 0
	yield(get_tree().create_timer(0.1), "timeout")
	set_dialogue_text()

func set_dialogue_text():
	var st:String = tr("DIA_%s_%s" % [num, progress])
	var arr:Array = st.split("|")
	if len(arr) > 2:
		for param in arr:
			var arr2:Array = param.split("=")
			if arr2[0] == "align":
				if arr2[1] == "left":
					$Panel/HBox.move_child($Panel/HBox/Portrait, 0)
				elif arr2[1] == "right":
					$Panel/HBox.move_child($Panel/HBox/Portrait, 1)
			elif arr2[0] == "img":
				$Panel/HBox/Portrait.texture = load("res://Graphics/Dialogue/%s" % arr2[1])
	st = arr[-1]
	RTL.bbcode_text = "[textFade]" + st
	$ArrowTimer.start((len(RTL.bbcode_text) / 15.0) / 5.0)

func _process(delta):
	RTL.visible_characters += 3

func _on_Next_pressed():
	progress += 1
	$Panel/Arrow.visible = false
	if tr("DIA_%s_%s" % [num, progress]) == "DIA_%s_%s" % [num, progress]:
		emit_signal("finished")
		$AnimationPlayer.play_backwards("FadeIn")
	else:
		emit_signal("button_clicked")
		set_dialogue_text()


func _on_ArrowTimer_timeout():
	$Panel/Arrow.visible = true
