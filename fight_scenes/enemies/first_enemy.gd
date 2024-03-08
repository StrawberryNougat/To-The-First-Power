extends CharacterBody2D

signal enemy_dead()

const bullet_scene = preload("res://fight_scenes/bullets/basic_bullet.tscn")
const reverse_bullet_scene = preload("res://fight_scenes/bullets/reverse_bullet.tscn")
@onready var shoot_timer = $shoot_timer
@onready var rotator = $rotator

@onready var phase_timer = $phase_timer
@onready var util_timer = $util_timer



var rotate_speed = 100
var spawn_point_count = 4
var radius = 100 
#control the wait time between phases
var phase_delay = .25
#controls bullet speed
var shot_speed = 100

#index into the attackOrder and attackLengths arrays
var curAttack = 0
#array for storing the order of attacks, each number is an attack type
#0: basic, 1: clock, 2: harder basic, 3: circles, 4: sprinkler, 5: *reverse, 6: rate change, 7: on off
var attackOrder = [0, 7, 4, 3, 1, 2, 6, 5, 1]
#array for storing the length of attacks, each number is a duration in seconds
var attackLengths = [5, 5.5, 10, 10, 10, 10, 10, 5, 5]

var enemy_health = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	startAttack(attackOrder[curAttack], attackLengths[curAttack])
	
	#pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var shouldRotate = true
	match attackOrder[curAttack]:
		1:
			if (util_timer.time_left <= 0):
				setRotation(rotator.rotation_degrees + 30)
				util_timer.wait_time = 3
				util_timer.start()
			shouldRotate = false
		4:
			if (util_timer.time_left <= 0):
				shoot_timer.paused = false
				util_timer.start()
				reverseRotator()
			elif (util_timer.time_left <= .75):
				shoot_timer.paused = true
		7:
			if (util_timer.time_left <= 0):
				if (shoot_timer.paused):
					shoot_timer.paused = false
				else:
					if (phase_timer.time_left > .5):
						shoot_timer.paused = true
				util_timer.wait_time = .5
				util_timer.start()
	if (shouldRotate):
		setRotation(rotator.rotation_degrees + rotate_speed * delta)


func startAttack(type: int, delay: int):
	# depedning on the attack type passed in, change the variables which control the bullet spawning
	# when adding a new attack, add its number to the match and set the values desired. Radius can also be changed
	#define defaults here so they don't need to be explicitly set for every attack
	var starting_rotation = rotator.rotation_degrees
	shot_speed = 100
	
	match type:
		1: 
			rotate_speed = 0
			shoot_timer.wait_time = .1
			spawn_point_count = 6
			shot_speed = 300
		2:
			rotate_speed = 500
			shoot_timer.wait_time = .4
			spawn_point_count = 5
		3:
			rotate_speed = 3.33
			shoot_timer.wait_time = 1.5
			spawn_point_count = 36
		4:
			rotate_speed = 50
			shoot_timer.wait_time = .15
			spawn_point_count = 1
			starting_rotation = 135
			util_timer.wait_time = 2
			#shouldn't actually need to start the util timer if it gets restarted in process like  type 1's if (util_timer.time_left <= 0):
			util_timer.start()
		5:
			#waiting on character/enemy bullet differentiation, now boss hits itself
			rotate_speed = -50
			shoot_timer.wait_time = .15
			spawn_point_count = 1
			shot_speed = 340
			starting_rotation = 225
		6:
			rotate_speed = -100
			shoot_timer.wait_time = .1
			spawn_point_count = 2
		7:
			rotate_speed = 50
			shoot_timer.wait_time = .1
			spawn_point_count = 4
			shot_speed = 200
			util_timer.wait_time = .5
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
	var nextAttack = (curAttack + 1) % len(attackOrder)
	#wait some time after end of a phase
	await get_tree().create_timer(phase_delay).timeout
	startAttack(attackOrder[nextAttack], attackLengths[nextAttack])
	curAttack = nextAttack

#this timer controls how fast enemy shoots, on timeout it creates bullets at each child of the rotator
func _on_shoot_timer_timeout():
	var scene = bullet_scene
	match attackOrder[curAttack]:
		5:
			#placeholder until character bullets and enemy bullets are different
			scene = reverse_bullet_scene
		6:
			shot_speed = map(shoot_timer.wait_time, .05, .15, 100, 200)	
	for j in rotator.get_children():
		var bullet = scene.instantiate()# Replace with function body.
		bullet.speed = shot_speed
		get_tree().root.add_child(bullet)
		bullet.add_to_group("bullets")
		bullet.position = j.global_position
		bullet.rotation = j.global_rotation

	#make changes after each shot depending on current attack
	match attackOrder[curAttack]:
		3:
			shot_speed = cycle(shot_speed, [100, 80, 60])
		6:
			decreaseFireRate(.05, .20, .005, true)
			


#this method just simplifies rotation changes a little bit
func setRotation(new_rotation: float):
	rotator.rotation_degrees = fmod(new_rotation, 360)

#This method reverses the direction of the rotator
func reverseRotator():
	rotate_speed = -rotate_speed

#cycles through values in a given array, if curr is at index 1, returns val at index 2
func cycle(curr: float, values: Array):
	var i = 0
	for x in range(len(values)):
		if (values[i] == curr):
			i = x
	return values[(i + 1) % len(values)]
	
#decreases fire rate from min to max (smaller is faster) in steps of size change. 
#if loop is true, this wraps around to min after reaching max
func decreaseFireRate(min: float, max: float, change: float, loop: bool):
	shoot_timer.wait_time += change
	if (loop):
		if (shoot_timer.wait_time > max):
			shoot_timer.wait_time = min
	else:
		if (shoot_timer.wait_time > max):
			shoot_timer.wait_time = max

func map(x: float, in_min: float, in_max: float, out_min: float, out_max: float):
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;


func hit_enemy():
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
