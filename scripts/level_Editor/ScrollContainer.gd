extends ScrollContainer

onready var object_cursor=get_node("/root/main/Editor_Object")

func _ready() -> void:
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_leave")
	pass
	
func mouse_enter():
	print("scroll enter!")
	object_cursor.can_place=false
	object_cursor.hide()
	pass

func mouse_leave():
	print("scroll exited!")
	object_cursor.can_place=true
	object_cursor.show()
	pass
