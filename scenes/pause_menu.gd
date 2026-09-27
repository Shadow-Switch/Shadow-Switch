extends Control


func toggle_pause():
	get_tree().paused = !get_tree().paused
	$".".visible = get_tree().paused

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func _on_resume_pressed():
	toggle_pause()

func _on_restart_pressed():
	toggle_pause()
	Global.target_level = Global.current_level.scene_file_path.get_file().get_basename()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_pressed():
	toggle_pause()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
