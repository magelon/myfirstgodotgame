extends Node2D


onready var enemy=get_node("PlayerKinematicBody2D")

onready var active=false

func _ready() -> void:
	enemy.set_process(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_editor"):
		active=!active
		enemy.set_process(active)
