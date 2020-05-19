extends Node2D

var can_place=false
onready var level=get_node("/root/main/level")

var current_item

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	global_position=get_global_mouse_position()
	if(current_item!=null and can_place and Input.is_action_just_pressed("mb_left")):
		var new_item=current_item.instance()
		level.add_child(new_item)
		new_item.global_position=get_global_mouse_position()
		pass
