extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.is_action_pressed("ui_cancel"):
			get_tree().quit()
