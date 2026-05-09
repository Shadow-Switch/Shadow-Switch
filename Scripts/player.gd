extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

signal dimension_changed


func notify_dimension():
	emit_signal("change_dimension")

func _physics_process(delta):
	# 중력
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 점프
	if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 차원 전환
	if Input.is_action_just_pressed("ui_down"):
		Global.dimension = 1 - Global.dimension
		emit_signal("dimension_changed")

	# 이동
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	position = position.round()
	move_and_slide()
