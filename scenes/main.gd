extends Control


func _process(_delta):
	if Rect2(Vector2(80, 80), Vector2(160, 32)).has_point(get_local_mouse_position()):
		$Labels.visible = true
		$Hilight.visible = true
	else:
		$Labels.visible = false
		$Hilight.visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().quit()
