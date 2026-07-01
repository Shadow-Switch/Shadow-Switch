extends Node

var snow = preload("res://scenes/snow.tscn")


func _on_timer_timeout():
	var snow_instance = snow.instantiate()
	snow_instance.position = Vector2(randi() % 319, 0)
	add_child(snow_instance)
