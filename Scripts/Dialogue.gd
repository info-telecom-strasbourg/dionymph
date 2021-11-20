class_name Dialogue
extends Control

signal finished
signal button_clicked

var type:String
var num:int
var progress:int

func _ready():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("FadeIn")

func set_dialogue_text():
	$Panel/HBox/RichTextLabel.bbcode_text = "[textFade]" + tr("%s_%s_%s" % [type, num, progress])


func _on_Next_pressed():
	progress += 1
	if tr("%s_%s_%s" % [type, num, progress]) == "%s_%s_%s" % [type, num, progress]:
		emit_signal("finished")
		$AnimationPlayer.play_backwards("FadeIn")
	else:
		emit_signal("button_clicked")
		set_dialogue_text()
