extends CharacterBody2D

signal hit

@export var health : int
@export var speed : int
@export var jumpVel = -400.0

@onready var aniPlayer = $AnimationPlayer
@onready var spriteAni = $AnimatedSprite2D
@onready var swingHitbox = $swingBox

var enemyCollision = false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	#handling the sword swinging
	if Input.is_action_just_pressed("Swing") and !aniPlayer.is_playing():
		aniPlayer.play("swingSword")
		
	if aniPlayer.current_animation == "swingSword" and enemyCollision:
		hit.emit()
	#I don't understand why it was doing things the way it did
	#but in any case, this is for switching the side you are swinging on
	if Input.is_action_just_pressed("Left"):
		aniPlayer.play("switchLeft")
	elif Input.is_action_just_pressed("Right"):
		aniPlayer.play("switchRight")


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jumpVel
		spriteAni.play("jump")

	#Not sure why I tried reinventing the wheel
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * speed
		if is_on_floor():
			spriteAni.play("walk")
	else:
		velocity.x = 0
		if is_on_floor():
			spriteAni.play("default")
	move_and_slide()



func _on_swing_box_area_entered(area: Area2D) -> void:
	enemyCollision = true
	
func _on_swing_box_area_exited(area: Area2D) -> void:
	enemyCollision = false
