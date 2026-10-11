extends RigidBody2D

@export var health : int = 2

@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == $"../Player":
		player.hit.emit()
		#print('collided')


func _on_player_swing(id) -> void:
	if player.enemyCollision and id == $'Area2D'.get_rid():
		print("collided")
		linear_velocity.x = 200
