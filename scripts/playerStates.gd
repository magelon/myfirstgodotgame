#a singleton contains all states for player
extends Node2D

onready var player=get_node("PlayerKinematicBody2D")
onready var cam=get_node("PlayerKinematicBody2D/Camera2D")

onready var active=false

func _ready() -> void:
	player.set_process(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_editor"):
		active=!active
		player.set_process(active)
		cam.current=active

