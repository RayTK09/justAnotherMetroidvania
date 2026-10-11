extends Node2D

@onready var player = $".."
@onready var health = $"..".health
@onready var hearts = [$heart1, $heart2, $heart3, $heart4, $heart5]
var heartAlive = "res://Sprites/playerSprites/heart.png"
var heartDead = "res://Sprites/playerSprites/heartBroken.png"
var loadAlive = load("res://Sprites/playerSprites/heart.png")
var loadDead = load("res://Sprites/playerSprites/heartBroken.png")


func _on_player_hit() -> void:
	if $"../invinciblityFrames".is_stopped():
		hearts[health].texture = loadDead
		health -= 1
	if health < 0:
		health = 0
		$"../Control/Label".visible = true
		player.disableMovement = true
	if $"../invinciblityFrames".is_stopped():
		$"../audioPlayer".play()
		$"../invinciblityFrames".start()
		if !player.disableMovement: 
			$"../disableMovement".start()
			player.disableMovement = true
		player.velocity.y = -200
		if !$"../AnimatedSprite2D".flip_h:
			player.velocity.x = 130
		if $"../AnimatedSprite2D".flip_h:
			player.velocity.x = -130
	print(health)

func _on_player_heal(amount: int) -> void:
	hearts[health].texture = loadAlive
	for i in range(health, health + amount + 1):
		if i >= 5:
			i = 4
		#print(i)
		hearts[i].texture = loadAlive
	health += amount
	if health >= 5:
		health = 4
	#print(health)
