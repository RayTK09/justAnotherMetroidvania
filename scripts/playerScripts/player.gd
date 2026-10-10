extends CharacterBody2D

signal hit

@export var health : int = 5
@export var speed : int
@export var jumpVel = -400.0

@onready var aniPlayer = $AnimationPlayer
@onready var spriteAni = $AnimatedSprite2D
@onready var swingHitbox = $swingBox

var enemyCollision = false
var jumped = false

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
	
	#coyote time
	if !is_on_floor() and $coyoteTime.is_stopped() and !jumped:
		$coyoteTime.start()
	
	if is_on_floor():
		jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and !jumped:
		velocity.y = jumpVel
		jumped = true
	
	if velocity.y < 0:
		spriteAni.play("jump")
	
	if velocity.y > 0:
		spriteAni.play("I'm falling!")

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

func _on_coyote_time_timeout() -> void:
	jumped = true
