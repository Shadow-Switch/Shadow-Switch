extends Area2D

var stop = false

signal entered_exit(path)


func _ready():
	add_to_group("exit")

func _on_body_entered(body):
	if stop == true:
		return
	if body.name == "Player":
		stop = true
		emit_signal("entered_exit", "res://scenes/levels/" + get_meta("target_level") + ".tscn")
