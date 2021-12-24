extends Node

# Aller dans les paramètres et autoload ce script pour être appelé de n'importe où
# Servira à sauvegarder la position du joueur entre 2 scènes 
# Ces changements de position se font dans le script Player.gd et dans World.gd

### Selon arith metic :
### Meilleure façon de gérer les scènes est de faire un dictionnaire

var player_pos : Vector2

## Func pour changer de monde
func change_scene(to_scene):
	get_tree().change_scene(to_scene)
