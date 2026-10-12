extends CharacterBody2D

#pathfinding was made with the help of a tutorial by DevWorm on YT

@export var health : int = 2
@export var player : Node2D

@onready var navAgent = $NavigationAgent2D
@onready var rayCast = $playerDetect
@onready var animationControl = $AnimationPlayer

var speed = 1.5
var canSeePlayer = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
	#print($invuln.time_left)
	var direction = to_local(navAgent.get_next_path_position())
	velocity = direction * speed
	move_and_slide()
	#print(navAgent.get_target_position())
	#print(position)
	
	#Raycast line of sight
	if rayCast.is_colliding():
		var shape = rayCast.get_collider().get("name")
		if shape == player.get("name"):
			canSeePlayer = true
	elif !rayCast.is_colliding():
		canSeePlayer = false
		


func makePath() -> void:
	if canSeePlayer:
		navAgent.set_target_position(Vector2(player.position.x, position.y)) 


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == $"../Player":
		player.hit.emit()
		#print('collided')


func _on_player_swing(id) -> void:
	if player.enemyCollision and id == $'Area2D'.get_rid() and $invuln.is_stopped():
		#print("collided")
		$invuln.start()
		if $Sprite2D.flip_h:
			position.x += 30
		elif !$Sprite2D.flip_h:
			position.x -= 30
		health -= 1

#detect if the player is around the enemy
func _on_player_near_body_entered(body: Node2D) -> void:
	if body.get('name') == player.get("name"):
		#print("detected!")
		canSeePlayer = true
		#switch enemy direction
	if player.position.x > position.x:
		animationControl.play("switch right")
	elif player.position.x < position.x:
		animationControl.play("switch left")


func _on_player_near_body_exited(body: Node2D) -> void:
	if body.get('name') == player.get("name"):
		canSeePlayer = false

#make a path every half a second
func _on_timer_timeout() -> void:
	makePath()
