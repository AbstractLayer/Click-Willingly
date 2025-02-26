extends CharacterBody2D

@onready var variable_jump: Timer = %VariableJump

var speed = 10000
var jump_velocity = -400

func _ready() -> void:
	set_physics_process(false)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#Handle jump.
	if Input.is_action_pressed("Space") and is_on_floor():
		variable_jump.start()
		velocity.y = jump_velocity
	velocity.x = speed * delta

	move_and_slide()


func _on_dino_game_itself_is_physics_return() -> void:
	set_physics_process(true)


func _on_dino_game_itself_speedup_character() -> void:
	for speedup in range(25):
		await get_tree().create_timer(1).timeout
		speed += 100

func _on_variable_jump_timeout() -> void:
	if not Input.is_action_pressed("Space"):
		if velocity.y < 100:
			velocity.y = 0
