extends Node2D


func _ready():
	load_level("res://scenes/levels/1.tscn")
	$Player.dimension_changed.connect(apply_dimension)

func apply_dimension():
	# 에러처리
	if Global.current_level == null:
		return
	# 레이어 보이기 변경
	if Global.dimension == 0:
		Global.current_level.Real_Layer.visible = true
		Global.current_level.Shadow_Layer.visible = false
		Global.current_level.Real_Layer.set_collision_enabled(true)
		Global.current_level.Shadow_Layer.set_collision_enabled(false)
	else:
		Global.current_level.Real_Layer.visible = false
		Global.current_level.Shadow_Layer.visible = true
		Global.current_level.Real_Layer.set_collision_enabled(false)
		Global.current_level.Shadow_Layer.set_collision_enabled(true)

func load_level(path):
	# 레벨 씬 변경
	if Global.current_level:
		Global.current_level.queue_free()
	var level = load(path).instantiate()
	add_child(level)
	Global.current_level = level
	# 차원 Real로 변경
	Global.dimension = 0
	apply_dimension()
