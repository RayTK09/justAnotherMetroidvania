extends CharacterBody2D


@export var speed : int
@export var jumpVel = -400.0

@onready var aniPlayer = $AnimationPlayer

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Swing") and !aniPlayer.is_playing():
		aniPlayer.play("swingSword")
	if Input.is_action_just_pressed("Left"):
		scale.x = -1
	elif Input.is_action_just_pressed("Right"):
		scale.x = 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jumpVel

	#Not sure why I tried reinventing the wheel
	var direction := Input.get_axis("Left", "Right")
	print(direction)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0

	move_and_slide()
