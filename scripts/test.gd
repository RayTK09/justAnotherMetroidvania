extends Node2D

var creature = load("res://Scenes/evil_ass_creature.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().node_added
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
