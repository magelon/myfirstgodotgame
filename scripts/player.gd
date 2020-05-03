extends actor

const cooldown=preload("res://scripts/cooldown.gd")

onready var fist_cooldown=cooldown.new(0.5)

signal hpChanged(amount)

var timeStop
var state_machine
var coins
var hp

func _ready() -> void:
	state_machine=$Sprite/AnimationTree.get("parameters/playback")
	state_machine.start("idle")
	coins=PlayerStates.coins
	hp=PlayerStates.hp

	#it will run parent physics process as well
func _process(delta: float) -> void:
	
	#timer delta is the time between every frame
	fist_cooldown.tick(delta)
	
	var is_jump_interrupted: =Input.is_action_just_released("move_up") and velocity.y<0.0
	var direction:= get_direction()
	
	#get current animation
	#var current=state_machine.get_current_node()
	
	#facing the right direction
	if Input.get_action_strength("move_left"):
		get_node("Sprite").set_scale(Vector2(-1,1))
	elif Input.get_action_strength("move_right"):
		get_node("Sprite").set_scale(Vector2(1,1))
		
		
	velocity=calculate_move_velocity(velocity,direction,speed,is_jump_interrupted)
	#move and slide build in function works to smooth frame rate
	velocity=move_and_slide(velocity,FLOOR_NORMAL)
	
	#switch between different attacks or actions
	if Input.is_action_just_pressed("attack1") and fist_cooldown.is_ready() and hp>0:
			print("hp: "+str(hp))
			state_machine.travel("fistcombo")
	elif Input.get_action_strength("move_down")==1 and hp>0:
			#pause_temporary(3)
			print("The world!")
			state_machine.travel("squat")
	elif velocity.x!=0.0 and velocity.y==0.0 and !timeStop:
			state_machine.travel("walk")
	elif velocity.y!=0.0 and !timeStop:
			state_machine.travel("jump")
	elif (velocity.x==0.0 and 
			velocity.y==0.0 and
			!timeStop and 
			Input.get_action_strength("move_down")!=1
			and hp>0):
			state_machine.travel("idle")	
	elif hp<=0:
			state_machine.travel("die")	
	
func get_direction() -> Vector2:
		return Vector2(	 
				#get input action function return 1 if get action
				Input.get_action_strength("move_right")-Input.get_action_strength("move_left") if hp>0 else 0,
				-1.0 if Input.is_action_just_pressed("move_up") and is_on_floor() and hp>0 else 1.0 
		)

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction:Vector2,
	speed:Vector2,
	is_jump_interrupted: bool
	) -> Vector2:
		var new_velocity: =linear_velocity
		new_velocity.x=speed.x*direction.x
		new_velocity.y+=gravity*get_physics_process_delta_time()
		if direction.y==-1.0:
			new_velocity.y=speed.y*direction.y
		if is_jump_interrupted:
			new_velocity.y=0.0	
		return new_velocity
	#end


func _on_fistHit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		print("hit")
		area.get_parent().take_damage()

func take_damage() -> void:
	print("player take damage")
	hp=hp-1
	#update health globally
	PlayerStates.hp=hp
	state_machine.travel("hurt")
	if hp<=0:
		print("player died")
		velocity=Vector2.ZERO
		state_machine.travel("die")
	else:
		#change hp in hpbar
		emit_signal("hpChanged",hp)
		
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
	
func getCoin() -> void:
	coins=coins+1
	#update coins
	PlayerStates.coins=coins
	print(coins)
