extends KinematicBody2D
class_name actor

#limite speed so character will not out of control
export var speed:= Vector2(300.0,1000.0)
export var gravity:= 3000.0
var velocity: = Vector2.ZERO
#move and slide
const FLOOR_NORMAL: =Vector2.UP	
	
