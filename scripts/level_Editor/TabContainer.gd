extends TabContainer

onready var object_cursor=get_node("/root/main/Editor_Object")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_editor"):
		Global.playing=!Global.playing
		visible=!Global.playing
	pass	

func _on_TabContainer_mouse_entered():
	object_cursor.can_place=false
	object_cursor.hide()
	pass

func _on_TabContainer_mouse_exited():
	object_cursor.can_place=true
	object_cursor.show()
	pass
