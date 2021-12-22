extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var HeartUIFull = $HeartUIFull
onready var HeartUIEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts) # Limite entre valeurs ?
	if HeartUIFull != null:
		HeartUIFull.rect_size.x = hearts * 15

func set_max_hearts(value):
	max_hearts = max(value, 1) # Au moins un coeur
	self.hearts = min(hearts, max_hearts)
	if HeartUIEmpty != null:
		HeartUIEmpty.rect_size.x = max_hearts * 15

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
