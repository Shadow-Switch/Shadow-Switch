extends CharacterBody2D

var speed = randf_range(0.1, 1.0)
var wind = randf_range(-0.3, 0.3)


func _physics_process(_delta):
	if is_on_floor():
		queue_free()
	else:
		position.y += speed
		position.x += wind

	# position = position.round()
	move_and_slide()
