extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -800.0


var direction = 0
var go = 0
var ran = 5
var jump =5

@onready var animation = get_node("AnimationPlayer")
@onready var sprite = get_node("Sprite2D")
@onready var ray_left = $Rayleft
@onready var ray_right = $RayRight
@onready var timer = $Timer
@onready var eyes = $Eyes

func jump_():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	
func _on_timer_timeout() -> void:
	ran = randi_range(0, 10)
	jump = randi_range(0, 10)

func _physics_process(delta: float) -> void:
	#AI code ...
	if jump > 8:
		jump_()
	if go == 0:
		if ran > 4:
			if ran < 5:
				direction = -1
				go = 1
			if ran > 5:
				direction = 1
				go = 1
	if go == 1:
		if ran < 4:
			direction = 0
			go = 0
		
	if ray_left.is_colliding():
		jump_()
		if ray_left.is_colliding() and is_on_floor():
			if direction == -1:
				go = 0
				direction = 0
			if ray_right.is_colliding():
				direction = 0
				go = 0
			elif go == 0:
				direction = 1
				go = 1
	if ray_right.is_colliding():
		jump_()
		if ray_right.is_colliding() and is_on_floor():
			if direction == 1:
				go = 0
				direction = 0
			if ray_left.is_colliding():
				direction = 0
				go = 0
			elif go == 0:
				direction = -1
				go = 1
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction == -1:
		sprite.flip_h = true
		eyes.set_target_position(Vector2(500, 0))
	if direction == 1:
		sprite.flip_h = false
		eyes.set_target_position(Vector2(500, 0))
	if direction != 0:
		animation.play("walk")
	else:
		animation.play("idle")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
