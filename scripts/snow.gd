extends CharacterBody2D

var speed = randf_range(0.1, 1.0)


func _physics_process(_delta):
	if is_on_floor():
		await get_tree().create_timer(1.0).timeout
		queue_free()
	else:
		position.y += speed

	# position = position.round()
	move_and_slide()
