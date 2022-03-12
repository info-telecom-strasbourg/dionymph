extends Node2D

var play:bool = false
var c_sv:int = -1
enum Worlds {PRISON}
var curr_world:int = -1
var curr_NPC:int = -1
var dia_num:int = -1
var NPC_dialogue:Dialogue
onready var music_player = $AudioStreamPlayer
var world_scene:Node2D

func _ready():
	switch_music(load("res://Audio/Music/lullaby.ogg"))
	TranslationServer.set_locale("fr")

func _on_Menu_fade_menu():
	$AnimationPlayer.play("MenuFade")
	play = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if play:
		remove_child($Menu)
		switch_music(null)
		yield(get_tree().create_timer(1.0), "timeout")
		$SFX.stream = preload("res://Audio/Sounds/Door.wav")
		$SFX.play()
		yield(get_tree().create_timer(0.5), "timeout")
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

func add_dia(world:int, NPC:int, _dia_num:int, finished_event:String = "", on_click_event:String = ""):
	if is_instance_valid(NPC_dialogue):
		return
	NPC_dialogue = preload("res://Scenes/Dialogue.tscn").instance()
	NPC_dialogue.world = world
	NPC_dialogue.NPC = NPC
	NPC_dialogue.dia_num = _dia_num
	$Dialogue.add_child(NPC_dialogue)
	if is_instance_valid(world_scene) and "dont_move" in world_scene:
		world_scene.dont_move = true
		if not (NPC == 7 and _dia_num == 1):
			NPC_dialogue.connect("finished", self, "allow_movement")
	if on_click_event != "":
		NPC_dialogue.connect("button_clicked", self, on_click_event)
	if finished_event != "":
		NPC_dialogue.connect("finished", self, finished_event)

func allow_movement():
	world_scene.dont_move = false

func start_game():
	change_world(preload("res://Scenes/Prison2D.tscn"), 0)
	world_scene.modulate.a = 0.0
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(world_scene, "modulate", null, Color.white, 1.0)
	tween.interpolate_property(world_scene.get_node("Camera2D"), "zoom", Vector2(0.46, 0.46), Vector2(0.4, 0.4), 4.0, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
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
	if Input.is_action_just_released("interaction") and curr_NPC != -1 and not (is_instance_valid(world_scene) and "dont_move" in world_scene and world_scene.dont_move):
		if curr_NPC == 7:
			#add_dia(world:int, NPC:int, _dia_num:int, finished_event:String = "", on_click_event:String = ""):
			add_dia(0, curr_NPC, 1, "remove_barrel_anim")
		elif curr_NPC == 8:
			if not $Blur/BlackRect.is_connected("on_fade_in_finished", self, "change_world"):
				$Blur/BlackRect.connect("on_fade_in_finished", self, "show_secret_passage")
				$Blur/BlackRect.fade()
		elif curr_NPC == 9:
			add_dia(curr_world, curr_NPC, 1, "teleport_player_back")
		else:
			add_dia(curr_world, curr_NPC, 1)

func teleport_player_back():
	world_scene.teleport_player_back()

func show_secret_passage():
	$GameUI/HealthUI.visible = true
	change_world(preload("res://Scenes/SecretPassage.tscn"), 1)
	$Blur/BlackRect.disconnect("on_fade_in_finished", self, "show_secret_passage")

func change_world(scene, world_num):
	curr_world = world_num
	if is_instance_valid(world_scene):
		world_scene.queue_free()
	world_scene = scene.instance()
	add_child(world_scene)

func remove_barrel_anim():
	$Blur/BlackRect.connect("on_fade_in_finished", self, "remove_barrel")
	$Blur/BlackRect.connect("on_fade_out_finished", self, "resume_dialogue_7")
	$Blur/BlackRect.fade(0.5)

func resume_dialogue_7():
	yield(get_tree().create_timer(0.8), "timeout")
	$Blur/BlackRect.disconnect("on_fade_in_finished", self, "remove_barrel")
	$Blur/BlackRect.disconnect("on_fade_out_finished", self, "resume_dialogue_7")
	add_dia(0, 7, 2, "show_descendre")

func show_descendre():
	world_scene._on_Player_interact(8, tr("DESCENDRE"))

func remove_barrel():
	world_scene.get_node("YSort/Barrel/CollisionShape2D").disabled = true
	world_scene.get_node("YSort/Barrel").id = 8
	world_scene.get_node("YSort/Barrel").txt = tr(("DESCENDRE"))
	world_scene.get_node("YSort/Barrel/Sprite").texture = preload("res://Graphics/prison/prison 2D/escalier descendant.png")

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
