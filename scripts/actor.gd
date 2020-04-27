extends KinematicBody2D
class_name actor

#limite speed so character will not out of control
export var speed:= Vector2(300.0,1000.0)
export var gravity:= 3000.0
var velocity: = Vector2.ZERO

					#delta smooth per frame
func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	
	#move and slide build in function works to smooth frame rate
	velocity=move_and_slide(velocity)
