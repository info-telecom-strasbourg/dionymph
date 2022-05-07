extends Node2D

const TEST = true
var play:bool = false
var c_sv:int = -1
enum Worlds {PRISON}
var curr_world:int = -1
var event_data:Dictionary = {}
var dia_num:int = -1
var NPC_dialogue:Dialogue
onready var music_player = $AudioStreamPlayer
var world_scene:Node2D

func _ready():
	if TEST:
		remove_child($Menu)
		$GameUI/HealthUI.visible = true
		change_world(preload("res://Maps/Arcknot/Maison1.tscn"), 1)
		#change_world(preload("res://Maps/passage_secret/SecretPassage1.tscn"), 1)
		#change_world(preload("res://Maps/Village_part1.tscn"), 4)
		#world_scene.get_node("Teleport").monitoring = false
	else:
		switch_music(preload("res://Audio/Music/lullaby.ogg"))
		TranslationServer.set_locale("fr")

func _on_Menu_fade_menu():
	$AnimationPlayer.play("MenuFade")
	play = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if play:
		remove_child($Menu)
		switch_music(null)
		yield(get_tree().create_timer(1.0), "timeout")
		var intro:Node2D = preload("res://Scenes/Intro.tscn").instance()
		add_child(intro)
		intro.position = Vector2(384, 240)
		intro.get_node("AnimationPlayer").play("Anim", -1, 5.0)
		intro.get_node("AnimationPlayer").connect("animation_finished", self, "remove_intro", [intro])

func remove_intro(anim:String, intro:Node2D):
	remove_child(intro)
	intro.queue_free()
	yield(get_tree().create_timer(0.2), "timeout")
	$SFX.stream = preload("res://Audio/Sounds/Door.wav")
	$SFX.play()
	yield(get_tree().create_timer(0.5), "timeout")
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
	change_world(preload("res://Maps/Chateau/Prison2D.tscn"), 0)
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
	if Input.is_action_just_released("interaction") and not event_data.empty() and not (is_instance_valid(world_scene) and "dont_move" in world_scene and world_scene.dont_move):
		if event_data.has("NPC"):
			add_dia(curr_world, event_data.NPC, 1, event_data.event if event_data.has("event") else "")
		elif event_data.has("event"):
			callv(event_data.event, event_data.event_args if event_data.has("event_args") else [])
		hide_event_data()

func teleport_player_to_prau():
	world_scene.teleport_player_to_prau()
	
func teleport_player_back():
	world_scene.teleport_player_back()

func show_secret_passage():
	$Blur/BlackRect.fade(0.7)
	yield($Blur/BlackRect, "on_fade_in_finished")
	$GameUI/HealthUI.visible = true
	change_world(preload("res://Maps/SecretPassage.tscn"), 1)

func afficher_chateau():
	$Blur/BlackRect.fade(0.7)
	yield($Blur/BlackRect, "on_fade_in_finished")
	$GameUI/HealthUI.visible = true
	change_world(preload("res://Maps/Chateau/Chateau_rez_de_chaussée.tscn"), 2)

func change_world(scene, world_num):
	curr_world = world_num
	if is_instance_valid(world_scene):
		world_scene.queue_free()
	world_scene = scene.instance()
	add_child(world_scene)

func remove_barrel_anim():
	$Blur/BlackRect.connect("on_fade_in_finished", self, "remove_barrel")
	$Blur/BlackRect.connect("on_fade_out_finished", self, "resume_dialogue_7")
	$Blur/BlackRect.fade(0.7)

func resume_dialogue_7():
	yield(get_tree().create_timer(0.8), "timeout")
	$Blur/BlackRect.disconnect("on_fade_in_finished", self, "remove_barrel")
	$Blur/BlackRect.disconnect("on_fade_out_finished", self, "resume_dialogue_7")
	add_dia(0, 7, 2, "show_descendre")

func show_descendre():
	show_event_data(tr("DESCENDRE"), {"event":"show_secret_passage"})

func remove_barrel():
	world_scene.get_node("YSort/Barrel/CollisionShape2D").disabled = true
	world_scene.get_node("YSort/Barrel").event = "show_secret_passage"
	world_scene.get_node("YSort/Barrel").event_args = []
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

func show_event_data(txt:String, data:Dictionary):
	event_data = data
	$Dialogue/Talk/HBox/Label.text = txt
	$Dialogue/Talk/AnimationPlayer.play("TalkAnim")


func hide_event_data():
	event_data.clear()
	if $Dialogue/Talk.modulate.a == 1.0:
		$Dialogue/Talk/AnimationPlayer.play_backwards("TalkAnim")

func open_chest():
	print(event_data.contents)
