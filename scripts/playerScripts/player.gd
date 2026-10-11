extends CharacterBody2D

signal hit
signal heal(amount : int)
signal swing


@export var health : int = 5
@export var speed : int
@export var jumpVel = -400.0

@onready var aniPlayer = $AnimationPlayer
@onready var spriteAni = $AnimatedSprite2D
@onready var swingHitbox = $swingBox

var enemyCollision = false
var jumped = false
var disableMovement = false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	#handling the sword swinging
	if Input.is_action_just_pressed("Swing") and !aniPlayer.is_playing():
		aniPlayer.play("swingSword")
		
	if aniPlayer.current_animation == "swingSword" and enemyCollision:
		swing.emit()
	#this is for switching the side you are swinging on
	if Input.is_action_just_pressed("Left"):
		aniPlayer.play("switchLeft")
	elif Input.is_action_just_pressed("Right"):
		aniPlayer.play("switchRight")


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	#coyote time
	if !is_on_floor() and $coyoteTime.is_stopped() and !jumped:
		$coyoteTime.start()
	
	if is_on_floor():
		jumped = false
	
	#wallClimbing
	#its a mess
	if is_on_wall():
		jumped = false
	if is_on_wall() and jumped:
		velocity.y = jumpVel / 2
		if spriteAni.flip_h:
			velocity.x = -20
		else:
			velocity.x = 20
	#print(velocity)
	
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
	if direction and !disableMovement:
		velocity.x = direction * speed
		if is_on_floor():
			spriteAni.play("walk")
	elif !disableMovement:
		velocity.x = 0
		if is_on_floor():
			spriteAni.play("default")
			
	move_and_slide()
	#print(velocity)
	#print($invinciblityFrames.time_left)


func _on_swing_box_area_entered(area: Area2D) -> void:
	enemyCollision = true
	
func _on_swing_box_area_exited(area: Area2D) -> void:
	enemyCollision = false

func _on_coyote_time_timeout() -> void:
	jumped = true

func _on_button_2_pressed() -> void:
	if $invinciblityFrames.is_stopped():
		hit.emit()
		$invinciblityFrames.start()
		if !disableMovement: 
			$disableMovement.start()
			disableMovement = true
		velocity.y = -200
		if !spriteAni.flip_h:
			velocity.x = 120
		if spriteAni.flip_h:
			velocity.x = -120

func _on_button_pressed() -> void:
	heal.emit(3)

func _on_disable_movement_timeout() -> void:
	disableMovement = false

func _on_invinciblity_frames_timeout() -> void:
	$invinciblityFrames.stop()
