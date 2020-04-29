extends "res://scripts/actor.gd"

const cooldown=preload("res://scripts/cooldown.gd")

onready var fist_cooldown=cooldown.new(1.5)

var state_machine

onready var eyeRay=get_node("Sprite").get_node("eyeRay")


func _ready() -> void:
	set_physics_process(false)
	velocity.x=-speed.x
	state_machine=$Sprite/AnimationTree.get("parameters/playback")
	state_machine.start("idle")

func _process(delta: float) -> void:
	fist_cooldown.tick(delta)
	velocity.y+=gravity*get_physics_process_delta_time()
	
	#raycast2d eye ray
	if eyeRay.is_colliding():
		print("collid")
		state_machine.travel("fistcombo")
		
	
	if is_on_wall() :
		velocity.x *=-1.0
	velocity.y=move_and_slide(velocity,FLOOR_NORMAL).y	
	
	if velocity.x>0.0:
		get_node("Sprite").set_flip_h(false)
	
	if velocity.x<0.0:
		get_node("Sprite").set_flip_h(true)
	
	
	if velocity.x!=0.0 and velocity.y==0.0 :
			state_machine.travel("walk")
	elif velocity.y!=0.0 :
			state_machine.travel("jump")
	elif health<=0:
			state_machine.travel("die")	
	elif velocity.x==0.0 and velocity.y==0.0 :
			state_machine.travel("idle")	

func _on_fistHit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		area.take_damage()

func take_damage() -> void:
	print("hurt")
	health=health-1
	print(health)
	state_machine.travel("hurt")
	if fist_cooldown.is_ready() and health>0:
		velocity.x=-speed.x
	else:
		velocity=Vector2.ZERO
	if health<=0:
		print("die")
		state_machine.travel("die")	
	
