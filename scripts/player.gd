extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
var is_dead = false
var last_floor = Vector2(8, 8)

signal dimension_changed


func _physics_process(delta):
	# 차원 전환
	if Input.is_action_just_pressed("switch_dimension"):
		Global.dimension = 1 - Global.dimension
		emit_signal("dimension_changed")
		screen_shake(0.05, 1)
		$AudioStreamPlayer.playing = true

	#입력 막기
	if is_dead:
		return

	# 중력
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 점프
	if (Input.is_action_pressed("jump") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 이동
	var direction := int(Input.get_axis("move_left", "move_right"))
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# 적용
	move_and_slide()

	# 프레임 전환
	$Sprite2D.frame = (sign(int(velocity.y)) + 1)* 3 + (sign(int(velocity.x)) + 1)

	# 가시 체크
	var current_layer = Global.current_level.RealLayer
	if Global.dimension == 1:
		current_layer = Global.current_level.ShadowLayer
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.name == "Spike" and collider.get_parent() == current_layer:
			die()
			return

	# 바닥 위치 저장 (좌/우 레이캐스트 모두 체크)
	if is_on_floor() and $RayCast2DLeft.is_colliding() and $RayCast2DRight.is_colliding():
		var left_collider = $RayCast2DLeft.get_collider()
		var right_collider = $RayCast2DRight.get_collider()
		if (left_collider and not "Spike" == left_collider.name) and (right_collider and not "Spike" == right_collider.name):
			last_floor = snap_to_grid(global_position)

	# 픽셀에 스냅
	position = position.round()

func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		(floor(pos.x / 16) * 16) + 8,
		(floor(pos.y / 16) * 16) + 8
	)

func die():
	# 안전한 위치 저장 및 죽었는지 확인
	var safe_floor = last_floor
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO

	# 효과
	screen_shake(0.2, 1)
	await play_die_animation()

	# 기다리기
	$Sprite2D.visible = false
	$Sprite2D.frame = 0
	await get_tree().create_timer(0.5).timeout

	# 리스폰
	global_position = safe_floor
	is_dead = false
	$Sprite2D.visible = true

func play_die_animation():
	var start = 10
	var end = 28
	var fps = 150.0
	var delay = 1.0 / fps

	for i in range(start, end + 1):
		$Sprite2D.frame = i
		await get_tree().create_timer(delay).timeout

func screen_shake(duration := 0.2, strength := 1):
	var camera = $Camera2D
	var original_pos = camera.position
	var time = 0.0

	while time < duration:
		camera.position = original_pos + Vector2(
			randi_range(-strength, strength),
			randi_range(-strength, strength)
		)
		await get_tree().process_frame
		time += get_process_delta_time()

	camera.position = original_pos
