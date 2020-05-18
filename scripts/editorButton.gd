extends Button



func _on_button_up() -> void:
	#change theme
	get_tree().change_scene("res://scens/levels/level1.tscn")
