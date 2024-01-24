extends CharacterBody2D

const bullet_scene = preload("res://fight_scenes/bullets/basic_bullet.tscn")
var current_form
var speed = 300
var bullet_scale = Vector2(2.0,2.0)
var health = 5
@onready var image = get_node("creature_current_design")

# Called when the node enters the scene tree for the first time.
func _ready():
	image.speed_up.connect(speed_up)
	image.strength_up.connect(strength_up)

func _process(_delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	move_and_slide()
	
func speed_up():
	speed = 500

func strength_up():
	bullet_scale = Vector2(4.0,4.0)

func hit():
	health = health - 1
	print("Hit!")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") and get_tree().current_scene.name == "first_fight":
		# Instantiate bullet and add it to scene
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		
		# Set bullet position, rotation, and scale
		# NOTE: position is offset to not instantiate in the CollisionShape2D of the creature
		# Currently, this is hard-coded, but once I figure out how to not do it this way I will fix it
		bullet.position = position + Vector2(40.0, 0.0)
		bullet.rotation = rotation
		bullet.apply_scale(bullet_scale)
		return
