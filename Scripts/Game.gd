extends Node2D

var play:bool = false
var c_sv:int = -1
enum Worlds {PRISON}
var curr_world:int = -1
var curr_NPC:int = -1
var dia_num:int = -1
var NPC_dialogue:Dialogue
onready var music_player = $AudioStreamPlayer

func _ready():
	switch_music(load("res://Audio/Music/dionymphlullaby.ogg"))
	TranslationServer.set_locale("fr")

func _on_Menu_fade_menu():
	$AnimationPlayer.play_backwards("MenuFade")
	play = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if play:
		remove_child($Menu)
		switch_music(null)
		add_dia(0, 1, 1, "start_game")
#		var intro:Node2D = preload("res://Scenes/Intro.tscn").instance()
#		add_child(intro)
#		intro.position = Vector2(384, 240)
#		intro.get_node("AnimationPlayer").play("Anim")
#		intro.get_node("AnimationPlayer").connect("animation_finished", self, "remove_intro", [intro])

func remove_intro(anim:String, intro:Node2D):
	remove_child(intro)
	intro.queue_free()
	add_dia(0, 1, 1, "start_game")

func add_dia(world:int, NPC:int, _dia_num:int, finished_event:String = ""):
	if is_instance_valid(NPC_dialogue):
		return
	NPC_dialogue = preload("res://Scenes/Dialogue.tscn").instance()
	NPC_dialogue.world = world
	NPC_dialogue.NPC = NPC
	NPC_dialogue.dia_num = _dia_num
	$Dialogue.add_child(NPC_dialogue)
	if finished_event != "":
		NPC_dialogue.connect("finished", self, finished_event)
	
func start_game():
	var prison = preload("res://Scenes/Prison2D.tscn").instance()
	prison.modulate.a = 0.0
	add_child(prison)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(prison, "modulate", null, Color.white, 1.0)
	tween.interpolate_property(prison.get_node("Camera2D"), "zoom", Vector2(0.46, 0.46), Vector2(0.4, 0.4), 4.0, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	remove_child(tween)
	tween.queue_free()

func save_game():
	var save_file = File.new()
	save_file.open("user://Save%s.sav" % [c_sv], File.WRITE)
	var save_info:Dictionary = {
		"curr_world":curr_world,
		"player_position":Vector2.ZERO,
	}
	save_file.store_var(save_info)
	save_file.close()

func load_game(slot:int):
	var save_file = File.new()
	save_file.open("user://Save%s.sav" % [slot], File.READ)
	var save_info:Dictionary = save_file.get_var()
	save_file.close()
	for key in save_info:
		if key in self:
			self[key] = save_info[key]

func _input(event):
	if Input.is_action_just_released("interaction") and curr_NPC != -1:
		add_dia(0, curr_NPC, 1)

func switch_music(src):
	#Music fading
	var tween = $MusicTween
	if music_player.playing:
		tween.stop_all()
		tween.remove_all()
		tween.interpolate_property(music_player, "volume_db", null, -60, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_all_completed")
	if src != null:
		music_player.stream = src
		music_player.play()
		tween.interpolate_property(music_player, "volume_db", -20, 0, 2, Tween.TRANS_EXPO, Tween.EASE_OUT)
		tween.start()
