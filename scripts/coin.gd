extends Area2D

onready var anim_player: AnimationPlayer=get_node("AnimationPlayer")

func _on_Area2D_area_entered(area: Area2D) -> void:
	anim_player.play("fadeOut")
	area.get_parent().getCoin()
	
