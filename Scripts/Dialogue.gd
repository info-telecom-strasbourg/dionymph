class_name Dialogue
extends Control

onready var game = get_node("/root/Game")
signal finished
signal button_clicked

var b_finished:bool = false
var world:int
var num:int
var progress:int
onready var RTL:RichTextLabel = $Panel/RichTextLabel
var st:String
var tween:Tween

func _ready():
	progress = 1
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("FadeIn")
	RTL.visible_characters = 0
	yield(get_tree().create_timer(0.1), "timeout")
	set_dialogue_text()
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(game.get_node("Blur/ColorRect").material, "shader_param/amount", 0.0, 1.0, 0.2)
	tween.start()

func set_dialogue_text():
	st = tr("DIA_%s_%s_%s" % [world, num, progress])
	$Panel.rect_size.x = 640
	var arr:Array = st.split("|")
	var align_left = true
	$Panel/VBox/Portrait.texture = null
	if len(arr) > 2:
		for param in arr:
			var arr2:Array = param.split("=")
			if arr2[0] == "img":
				$Panel/VBox/Portrait.texture = load("res://Graphics/Dialogue/%s" % arr2[1])
			elif arr2[0] == "name":
				$Panel/VBox/Name.text = arr2[1]
	if $Panel/VBox/Portrait.texture:
		$Panel/VBox/Portrait.visible = true
	else:
		$Panel/VBox/Portrait.visible = false
	st = arr[-1]
	RTL.bbcode_text = "[textFade]" + st
	$ArrowTimer.start((len(RTL.bbcode_text) / 15.0) / 5.0)

func _process(delta):
	RTL.visible_characters += 3

func _input(event):
	if Input.is_action_just_released("interaction"):
		_on_Next_pressed()

func _on_Next_pressed():
	if $Panel/Arrow.visible:
		progress += 1
		$Panel/Arrow.visible = false
		if tr("DIA_%s_%s_%s" % [world, num, progress]) == "DIA_%s_%s_%s" % [world, num, progress]:
			b_finished = true
			$AnimationPlayer.play_backwards("FadeIn")
		else:
			emit_signal("button_clicked")
			set_dialogue_text()
	else:
		$Panel/Arrow.visible = true
		RTL.bbcode_text = st
		RTL.visible_characters = len(RTL.bbcode_text)

func _on_ArrowTimer_timeout():
	$Panel/Arrow.visible = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if b_finished:
		tween.stop_all()
		tween.reset_all()
		tween.remove_all()
		tween.interpolate_property(game.get_node("Blur/ColorRect").material, "shader_param/amount", 1.0, 0.0, 0.2)
		tween.start()
		emit_signal("finished")
		yield(tween, "tween_all_completed")
		get_parent().remove_child(self)
		queue_free()
