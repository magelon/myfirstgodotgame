extends Node2D

var can_place=false
var is_panning=true
onready var level=get_node("/root/main/level")
onready var editor=get_node("/root/main/cam_container")
onready var editor_cam=editor.get_node("Camera2D")

export var cam_spd=10
var current_item

func _ready() -> void:
	editor_cam.current=true
	pass

func _process(delta: float) -> void:
	#editor_cam.current=!Global.playing
	global_position=get_global_mouse_position()
	if(current_item!=null and can_place and Input.is_action_just_pressed("mb_left")):
		var new_item=current_item.instance()
		level.add_child(new_item)
		new_item.global_position=get_global_mouse_position()
		pass
	move_editor()
	is_panning=Input.is_action_pressed("mb_middle")
	pass
	
func move_editor():
	if Input.is_action_pressed("w"):
		editor.global_position.y-=cam_spd
	if Input.is_action_pressed("a"):
		editor.global_position.x-=cam_spd
	if Input.is_action_pressed("s"):
		editor.global_position.y+=cam_spd
	if Input.is_action_pressed("d"):
		editor.global_position.x+=cam_spd
	pass

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(event.is_pressed()):
			if(event.button_index==BUTTON_WHEEL_UP):
				editor_cam.zoom-=Vector2(0.1,0.1)
			if(event.button_index==BUTTON_WHEEL_DOWN):
				editor_cam.zoom+=Vector2(0.1,0.1)	
	if(event is InputEventMouseMotion):
		if(is_panning):
			editor.global_position-=event.relative*editor_cam.zoom
