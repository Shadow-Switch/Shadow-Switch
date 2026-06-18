extends Node2D


func _ready():
	load_level("res://scenes/levels/1.tscn")
	$Player.dimension_changed.connect(apply_dimension)

func _process(_delta):
	if DisplayServer.is_touchscreen_available():
		$CanvasLayer/TouchScreenJoystick.visible = true
	else:
		$CanvasLayer/TouchScreenJoystick.visible = false

func apply_dimension():
	if Global.current_level == null:
		return
	var real = Global.current_level.RealLayer
	var shadow = Global.current_level.ShadowLayer
	if Global.dimension == 0:
		real.visible = true
		shadow.visible = false
		real.set_collision_enabled(true)
		shadow.set_collision_enabled(false)
		real.get_node("Spike").set_collision_enabled(true)
		shadow.get_node("Spike").set_collision_enabled(false)
		$CanvasLayer/ColorRect.visible = false
		$CanvasLayer2/BackGroundColor.color = Color(0.506, 0.749, 0.925)
	else:
		real.visible = false
		shadow.visible = true
		real.set_collision_enabled(false)
		shadow.set_collision_enabled(true)
		real.get_node("Spike").set_collision_enabled(false)
		shadow.get_node("Spike").set_collision_enabled(true)
		$CanvasLayer/ColorRect.visible = true
		$CanvasLayer2/BackGroundColor.color = Color(0.403, 0.0, 0.62, 1.0)

func load_level(path):
	# 레벨 씬 변경
	if Global.current_level:
		Global.current_level.queue_free()
	var level = load(path).instantiate()
	add_child(level)
	Global.current_level = level
	# 차원 Real로 변경
	Global.dimension = 0
	$Player.position = Vector2(8, 8)
	for exit in level.get_tree().get_nodes_in_group("exit"):
		exit.connect("entered_exit", load_level)
	apply_dimension()
