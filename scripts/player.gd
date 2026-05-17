extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var is_dead = false
var safe_floor = Vector2.ZERO

signal dimension_changed


func _physics_process(delta):
	#입력 막기
	if is_dead:
		return

	# 중력
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 점프
	if (Input.is_action_pressed("jump") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 차원 전환
	if Input.is_action_just_pressed("switch_dimension"):
		Global.dimension = 1 - Global.dimension
		emit_signal("dimension_changed")

	# 이동
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# 프레임 전환
	$Sprite2D.frame = (sign(int(velocity.y)) + 1) * 3 + (sign(int(velocity.x)) + 1)

	# 적용
	position = position.round()
	move_and_slide()

	# 가시 체크
	var current_layer = Global.current_level.RealLayer
	if Global.dimension == 1:
		current_layer = Global.current_level.ShadowLayer

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.name == "Spike" and collider.get_parent() == current_layer:
			die()

	# 바닥 위치 저장
	if is_on_floor():
		safe_floor = snap_to_grid(global_position)

func notify_dimension():
	emit_signal("change_dimension")

func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		(floor(pos.x / 16) * 16) + 8,
		(floor(pos.y / 16) * 16) + 8
	)

func die():
	var last_floor = safe_floor
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	$Sprite2D.visible = false
	await get_tree().create_timer(0.2).timeout
	global_position = last_floor
	is_dead = false
	$Sprite2D.visible = true
