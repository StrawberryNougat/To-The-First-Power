extends CharacterBody2D

const bullet_scene = preload("res://fight_scenes/bullets/basic_bullet.tscn")
@onready var shoot_timer = $shoot_timer
@onready var rotator = $rotator

const rotate_speed = 100
const shoot_timer_wait = .2
const spawn_point_count = 4
const radius = 100 

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
	enemy_health = enemy_health - 1
	print("bang")

