extends "res://scripts/actor.gd"

const cooldown=preload("res://scripts/cooldown.gd")

onready var fist_cooldown=cooldown.new(1.5)
onready var jumpcd=cooldown.new(2.5)

var state_machine
var attacking
var timeStop
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
	jumpcd.tick(delta)
	
	velocity.y+=gravity*get_physics_process_delta_time()
	
	if velocity.x>0.0:
		get_node("Sprite").set_scale(Vector2(1,1))
		direction="right"
	
	if velocity.x<0.0:
		get_node("Sprite").set_scale(Vector2(-1,1))
		direction="left"
													#the world only effect alive
	if Input.get_action_strength("move_down")==1 and health>0:
	#manully trigger timestop
		pause_temporary(3)
	
	if !timeStop:
	#patrol function
		enemyPatrol()
	
	if is_on_wall() :
		velocity.x *=-1.0
	velocity.y=move_and_slide(velocity,FLOOR_NORMAL).y
	
	#if enemy is not attacking
	if !attacking and !timeStop:
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
	if (health>0):
		randomJump()
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
				print("not player can pass by jump back to patrol...")	
				attacking=false
				#if enemy facing right
				if 	direction=="right":
					#go right
					velocity.x=+speed.x
				else:
					velocity.x=-speed.x
		elif (!eyeRay.is_colliding() and alert):
			#must be somthing at back
			velocity=Vector2.ZERO
			#turn arround if face left turn right otherwise flip
			if direction=="left":
				velocity.x=+speed.x
				alert=false
			else:
				velocity.x=-speed.x
				alert=false
		else:
			#print("patroling...")
			attacking=false
				#if enemy facing right
			if 	direction=="right":
					#go right
				velocity.x=+speed.x
			else:
				velocity.x=-speed.x
	
				
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
		
#jump at randum
func randomJump()-> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randf_range(-10.0,10.0)>9.0 and jumpcd.is_ready():
		velocity.y=-600
	else:
		velocity.y=move_and_slide(velocity,FLOOR_NORMAL).y

func pause_temporary(seconds):
	
	state_machine.travel("timeStop")
	
	set_process(false)
	timeStop=true
	
	print("stop time")
	yield(get_tree().create_timer(seconds), "timeout")
	print("time restart")
	timeStop=false
	#get_node("Sprite/AnimationPlayer").set_active(true)
	
	set_process(true)
	
