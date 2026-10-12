extends RigidBody2D

@export var health : int = 2

@onready var player = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
	#print($invuln.time_left)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == $"../Player":
		player.hit.emit()
		#print('collided')


func _on_player_swing(id) -> void:
	if player.enemyCollision and id == $'Area2D'.get_rid() and $invuln.is_stopped():
		#print("collided")
		$invuln.start()
		linear_velocity.x = 200
		health -= 1


func _on_player_near_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
