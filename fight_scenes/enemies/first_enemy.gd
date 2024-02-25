extends CharacterBody2D

signal enemy_dead()

const bullet_scene = preload("res://fight_scenes/bullets/basic_bullet.tscn")
@onready var shoot_timer = $shoot_timer
@onready var rotator = $rotator
@onready var phase_one = $phase_one_timer
@onready var phase_two = $phase_two_timer

@onready var phase_timer = $phase_timer
@onready var util_timer = $util_timer



var rotate_speed = 100
var spawn_point_count = 4
var radius = 100 

#index into the attackOrder and attackLengths arrays
var curAttack = 0
#array for storing the order of attacks, each number is an attack type
var attackOrder = [0, 4, 3, 1, 2, 1]
#array for storing the length of attacks, each number is a duration in seconds
var attackLengths = [5, 10, 8, 9, 10, 6]

var enemy_health = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	util_timer.wait_time = 3
	startAttack(attackOrder[curAttack], attackLengths[curAttack])
	
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match attackOrder[curAttack]:
		1:
			if (util_timer.time_left <= 0):
				setRotation(rotator.rotation_degrees + 30)
				util_timer.wait_time = 3
				util_timer.one_shot = true
				util_timer.start()
		4:
			if (util_timer.time_left <= 0):
				shoot_timer.paused = false
				util_timer.one_shot = true
				util_timer.start()
				reverseRotator()
			elif (util_timer.time_left <= .5):
				shoot_timer.paused = true
			setRotation(rotator.rotation_degrees + rotate_speed * delta)
		_:
			setRotation(rotator.rotation_degrees + rotate_speed * delta)


func startAttack(type: int, delay: int):
	# depedning on the attack type passed in, change the variables which control the bullet spawning
	# when adding a new attack, add its number to the match and set the values desired. Radius can also be changed
	#could add variables for starting rotation here which are set by default to current rotation
	var starting_rotation = rotator.rotation_degrees
	match type:
		1: 
			rotate_speed = 0
			shoot_timer.wait_time = .1
			spawn_point_count = 6
		2:
			rotate_speed = 500
			shoot_timer.wait_time = .4
			spawn_point_count = 5
		3:
			rotate_speed = 4
			shoot_timer.wait_time = 1.5
			spawn_point_count = 36
		4:
			rotate_speed = 50
			shoot_timer.wait_time = .15
			spawn_point_count = 1
			starting_rotation = 135
			util_timer.wait_time = 2
			util_timer.one_shot = true
			#shouldn't actually need to start the util timer if it gets restarted in process like  type 1's if (util_timer.time_left <= 0):
			util_timer.start()
		_:
			rotate_speed = 100
			shoot_timer.wait_time = .2
			spawn_point_count = 4
			radius = 100 
	#Now create the spawner
	rotator.rotation_degrees = fmod(starting_rotation, 360)
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)
	shoot_timer.start()
	#done adding spawn points, now start timer until this attack ends
	phase_timer.wait_time = delay
	phase_timer.start()
	

#this timer controls how long an attack lasts, when it times out, it removes all the children of the rotator
func _on_phase_timer_timeout():
	#remove the rotator children from the last attack to prepare for next
	for n in rotator.get_children():
		rotator.remove_child(n)
		n.queue_free()
	#reset util timer and shoot timer to defaults so they are ready if next attack needs them
	shoot_timer.paused = false
	util_timer.one_shot = true
	util_timer.stop()
	#Go to the next attack, could make this index into an array later for more customization, or randomize
	curAttack = (curAttack + 1) % len(attackOrder)
	#wait some time after end of a phase
	await get_tree().create_timer(0.5).timeout
	startAttack(attackOrder[curAttack], attackLengths[curAttack])

#this timer controls how fast enemy shoots, on timeout it creates bullets at each child of the rotator
func _on_shoot_timer_timeout():
	for j in rotator.get_children():
		var bullet = bullet_scene.instantiate()# Replace with function body.
		get_tree().root.add_child(bullet)
		bullet.add_to_group("bullets")
		bullet.position = j.global_position
		bullet.rotation = j.global_rotation


#this method just simplifies rotation changes a little bit
func setRotation(new_rotation: float):
	rotator.rotation_degrees = fmod(new_rotation, 360)

#This method reverses the direction of the rotator
func reverseRotator():
	rotate_speed = -rotate_speed

func hit():
	if enemy_health <= 0:
		on_exit_fight()
		emit_signal("enemy_dead")
	else:
		enemy_health -= 1


func on_exit_fight():
	#stop shooting bullets.
	shoot_timer.stop()
	# This may be inefficient way of doing things, alternatively, we could make a data struct
	# when we spawn the bullets so we dont have to search, but we can do that when performance
	# becomes a problem.
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.queue_free()
