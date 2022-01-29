extends Control

func _ready():
	var fix_time  = OS.get_ticks_msec() - floor(OS.get_ticks_msec()/3600)*3600
	$VBoxContainer/Button.material.set_shader_param("start_time", fix_time / 1000.0)
