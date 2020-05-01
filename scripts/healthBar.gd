extends Control

onready var health_bar=$TextureProgress

func _on_PlayerKinematicBody2D_hpChanged(currentHP) -> void:
	health_bar.value=currentHP
