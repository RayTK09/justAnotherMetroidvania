extends CharacterBody2D

#pathfinding was made with the help of a tutorial by DevWorm on YT

@export var health : int = 2
@export var player : Node2D

@onready var navAgent = $NavigationAgent2D
@onready var rayCast = $playerDetect
@onready var animationControl = $AnimationPlayer

var speed = 50
var canSeePlayer = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
	#print($invuln.time_left)
	
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	if player.position.x > position.x - 30 and player.position.x < position.x + 30 and canSeePlayer:
		velocity.x = 0
	elif player.position.x > position.x and canSeePlayer:
		velocity.x = speed * 1
	elif player.position.x < position.x and canSeePlayer:
		velocity.x = speed * -1
		
	if canSeePlayer == false:
		velocity.x = 0
		
	move_and_slide()
	
	rayCastDetectPlayer()
	checkFloor()
	#print($"edge detection/detectRight".is_colliding())
	#print($"edge detection/detectLeft".is_colliding())


#Raycast line of sight
func rayCastDetectPlayer() -> void:
	if rayCast.is_colliding():
		var shape = rayCast.get_collider().get("name")
		if shape == player.get("name"):
			canSeePlayer = true
	elif !rayCast.is_colliding() and $lostPlayer.is_stopped():
		canSeePlayer = false

func checkFloor() -> void:
	if !$"edge detection/detectRight".is_colliding() and player.position.x < position.x and canSeePlayer:
		canSeePlayer = false
	elif !$"edge detection/detectLeft".is_colliding() and player.position.x > position.x and canSeePlayer:
		canSeePlayer = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get("name") == player.get("name"):
		player.hit.emit()
		#print('collided')


func _on_player_swing(hasSwung) -> void:
	if $invuln.is_stopped() and hasSwung:
		print("collided")
		$invuln.start()
		

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
		$lostPlayer.start()


func _on_lost_player_timeout() -> void:
	canSeePlayer = false
