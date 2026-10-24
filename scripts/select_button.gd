extends TextureButton


func _on_pressed():
	Global.target_level = get_meta("target_level")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
