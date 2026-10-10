extends Node2D

var enemy = load("res://Scenes/evil_ass_creature.tscn")
var enemyLoad
var enemyLoadTwo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemyLoad = enemy.instantiate()
	enemyLoadTwo = enemy.instantiate()
	add_child(enemyLoad)
	add_child(enemyLoadTwo)
	enemyLoad.position.y = -25
	enemyLoadTwo.position.y = -25
	enemyLoadTwo.position.x = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_hit() -> void:
	enemyLoad.health -= 5
