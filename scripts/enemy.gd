extends "res://scripts/actor.gd"

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#optimise performance of the game
	set_physics_process(false)
	velocity.x=-speed.x


func _process(delta: float) -> void:

	velocity.y+=gravity*get_physics_process_delta_time()
	
	if is_on_wall() :
		velocity.x *=-1.0
	velocity.y=move_and_slide(velocity,FLOOR_NORMAL).y	
	
	if velocity.x>0.0:
		get_node("AnimatedSprite").set_flip_h(false)
	
	if velocity.x<0.0:
		get_node("AnimatedSprite").set_flip_h(true)
	
	
	if velocity.x!=0.0 and velocity.y==0.0 :
			get_node("AnimatedSprite").set_animation("walk")
	elif velocity.y!=0.0 :
			get_node("AnimatedSprite").set_animation("jump")
	else :
			get_node("AnimatedSprite").set_animation("idle")	
