extends "res://scripts/actor.gd"

const cooldown=preload("res://scripts/cooldown.gd")

onready var fist_cooldown=cooldown.new(1.5)

var state_machine
var attacking
#possible danger
var alert
var direction

onready var eyeRay=get_node("Sprite").get_node("eyeRay")


func _ready() -> void:
	set_physics_process(false)
	velocity.x=-speed.x
	state_machine=$Sprite/AnimationTree.get("parameters/playback")
	state_machine.start("idle")
	attacking=false
	alert=false

func _process(delta: float) -> void:
	fist_cooldown.tick(delta)
	velocity.y+=gravity*get_physics_process_delta_time()
	
	if velocity.x>0.0:
		get_node("Sprite").set_scale(Vector2(1,1))
		direction="right"
	
	if velocity.x<0.0:
		get_node("Sprite").set_scale(Vector2(-1,1))
		direction="left"
	
	#patrol function
	enemyPatrol()
	
	if is_on_wall() :
		velocity.x *=-1.0
	velocity.y=move_and_slide(velocity,FLOOR_NORMAL).y
	
	#if enemy is not attacking
	if !attacking:
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
		area.get_parent().take_damage()

func enemyPatrol() -> void:
	#raycast2d eye ray
	#if enemy still alive
	if (health>0 and !alert):
		# if enemy see something
		if (eyeRay.is_colliding()):
			print("seen something! it's"+str(eyeRay.get_collider().get_name()))
			#stop and check
			velocity=Vector2.ZERO
			if(eyeRay.get_collider().get_name()=="PlayerKinematicBody2D"):
				alert=false
				print("player detected!!")
				#if enemy fist cooldown is ready
				if fist_cooldown.is_ready():
					print("attack...")
					attacking=true
					state_machine.travel("fistcombo")
			#if enemy see other than player
			else:
				print("not player back to patrol...")	
				attacking=false
				#if enemy facing right
				if 	direction=="right":
					#go right
					velocity.x=+speed.x
				else:
					velocity.x=-speed.x		
		else:
			print("patroling...")
			attacking=false
				#if enemy facing right
			if 	direction=="right":
					#go right
				velocity.x=+speed.x
			else:
				velocity.x=-speed.x
	#something hit me
	elif (health>0 and alert):
		#must be somthing at back
		velocity=Vector2.ZERO
		if (!eyeRay.is_colliding() 
			or (eyeRay.is_colliding() 
			and eyeRay.get_collider().get_name()!="PlayerKinematicBody2D")):
			#turn arround if face left turn right otherwise flip
			if direction=="left":
				velocity.x=+speed.x
				alert=false
			else:
				velocity.x=-speed.x
				alert=false
				
func take_damage() -> void:
	print("Got hurt!")
	health=health-1
	print(health)
	state_machine.travel("hurt")
	#freeze for a secon
	alert=true
	velocity=Vector2.ZERO
	#then looking for player left or right
	if health<=0:
		print("die")
		state_machine.travel("die")
		


