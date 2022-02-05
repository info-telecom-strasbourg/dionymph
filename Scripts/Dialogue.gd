class_name Dialogue
extends Control

onready var game = get_node("/root/Game")
signal finished
signal button_clicked

var b_finished:bool = false
var world:int
var NPC:int
var dia_num:int
var progress:int
onready var RTL:RichTextLabel = $Panel/RichTextLabel
var st:String#Dialogue text
var tween:Tween
var SFX_stream
var pitch:float = 2.0
var freq:float = 1.0

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
	var whole_text:String = tr("DIA_%s_%s_%s_%s" % [world, NPC, dia_num, progress])
	$Panel.rect_size.x = 640
	RTL.rect_size.x = 528
	var align_left = true
	$Panel/VBox/Portrait.texture = null
	var options_index:int = whole_text.find("{")
	if options_index != -1:
		st = whole_text.substr(0, options_index)
		while options_index != -1:
			var options_end_index:int = whole_text.find("}", options_index)
			var substr:String = whole_text.substr(options_index + 1, options_end_index - options_index - 1)
			var option_arr:Array = substr.split(";")
			var btn = preload("res://Scenes/DialogueOptionButton.tscn").instance()
			btn.get_node("Label").text = option_arr[1]
			btn.connect("pressed", self, "on_option_pressed", [int(option_arr[0])])
			$Panel/OptionButtons.add_child(btn)
			
			options_index = whole_text.find("{", options_index + 1)
	else:
		st = whole_text
	SFX_stream = null
	var arr:Array = st.split("|")
	if len(arr) > 2:
		for param in arr:
			var arr2:Array = param.split("=")
			if arr2[0] == "prota":
				SFX_stream = load("res://Audio/Sounds/DialogueSound.wav")
				pitch = 2
				freq = 1.0
			if arr2[0] == "prota":
				$Panel/VBox/Portrait.texture = preload("res://Graphics/Dialogue/Hero.png")
			elif arr2[0] == "img":
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
	if not SFX_stream:
		if NPC == 3:
			pitch = 1
			freq = 0.8
			SFX_stream = load("res://Audio/Sounds/DialogueSound.wav")
		elif NPC == 4:
			pitch = 1.5
			freq = 0.6
			SFX_stream = load("res://Audio/Sounds/DialogueSound.wav")
		elif NPC == 5:
			pitch = 5
			freq = 1.2
			SFX_stream = load("res://Audio/Sounds/DialogueSound.wav")
	if SFX_stream:
		$SFX.stream = SFX_stream
		$SFXTimer.start()

func _process(delta):
	RTL.visible_characters += 3

func _input(event):
	if Input.is_action_just_released("roll") or Input.is_action_just_released("interaction"):
		_on_Next_pressed()

func _on_Next_pressed():
	if $Panel/OptionButtons.visible:
		return
	if $Panel/Arrow.visible:
		if $Panel/OptionButtons.get_child_count() != 0:
			$Panel/OptionButtons.visible = true
			var fix_time  = OS.get_ticks_msec()# - floor(OS.get_ticks_msec()/3600.0)*3600.0
			var i:int = 0
			for btn in $Panel/OptionButtons.get_children():
				btn.material.set_shader_param("start_time", fix_time / 1000.0)
				btn.material.set_shader_param("phase", 0.5 * i)
				i += 1
			$Panel/Arrow.visible = false
			RTL.visible = false
		else:
			progress += 1
			$Panel/Arrow.visible = false
			if tr("DIA_%s_%s_%s_%s" % [world, NPC, dia_num, progress]) == "DIA_%s_%s_%s_%s" % [world, NPC, dia_num, progress]:
				b_finished = true
				$AnimationPlayer.play_backwards("FadeIn")
			else:
				emit_signal("button_clicked")
				set_dialogue_text()
	else:
		$Panel/Arrow.visible = true
		$SFXTimer.stop()
		RTL.bbcode_text = st
		RTL.visible_characters = len(RTL.bbcode_text)

func _on_ArrowTimer_timeout():
	$Panel/Arrow.visible = true
	$SFXTimer.stop()

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

func on_option_pressed(_dia_num:int):
	RTL.visible = true
	$Panel/OptionButtons.visible = false
	dia_num = _dia_num
	progress = 1
	for option in $Panel/OptionButtons.get_children():
		$Panel/OptionButtons.remove_child(option)
		option.queue_free()
	set_dialogue_text()


func _on_SFXTimer_timeout():
	$SFX.volume_db = linear2db(range_lerp(pitch, 0, 10, 1, 0)) + 1.0
	$SFXTimer.start(randf() * 0.06 / freq + 0.06 / freq)
	$SFX.pitch_scale = randf() * 0.1 * pitch + 0.4 * pitch
	$SFX.play()
