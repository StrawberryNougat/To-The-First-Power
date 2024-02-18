extends CharacterBody2D

signal enemy_dead()

const bullet_scene = preload("res://fight_scenes/bullets/basic_bullet.tscn")
@onready var shoot_timer = $shoot_timer
@onready var rotator = $rotator
@onready var phase_one = $phase_one_timer
@onready var phase_two = $phase_two_timer



var rotate_speed = 100
var shoot_timer_wait = .2
var spawn_point_count = 4
var radius = 100 

var enemy_health = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)
	shoot_timer.wait_time = shoot_timer_wait
	shoot_timer.start()
	phase_one.wait_time = 10
	phase_two.wait_time = 20
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)


func _on_shoot_timer_timeout():
	for j in rotator.get_children():
		var bullet = bullet_scene.instantiate()# Replace with function body.
		get_tree().root.add_child(bullet)
		bullet.add_to_group("bullets")
		bullet.position = j.global_position
		bullet.rotation = j.global_rotation

func hit():
	if enemy_health <= 0:
		on_exit_fight()
		emit_signal("enemy_dead")
	else:
		enemy_health -= 1


func _on_phase_one_timer_timeout():
	rotate_speed = 0
	shoot_timer_wait = .1
	#pass # Replace with function body.


func _on_phase_two_timer_timeout():
	rotate_speed = 500
	shoot_timer_wait = .4
	#pass # Replace with function body.

func on_exit_fight():
	#stop shooting bullets.
	shoot_timer.stop()
	# This may be inefficient way of doing things, alternatively, we could make a data struct
	# when we spawn the bullets so we dont have to search, but we can do that when performance
	# becomes a problem.
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.queue_free()
