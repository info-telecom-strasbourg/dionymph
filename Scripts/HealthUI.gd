extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

func set_hearts(value):
	$TextureProgress.value = value
	$Label.text = "%s / %s" % [$TextureProgress.value, $TextureProgress.max_value]

func set_max_hearts(value):
	$TextureProgress.max_value = value

func _ready():
	$TextureProgress.max_value = PlayerStats.max_health
	$TextureProgress.value = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
