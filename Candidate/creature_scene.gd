extends CharacterBody2D

const bullet_scene = preload("res://fight_scenes/bullets/basic_bullet.tscn")
var current_form
var speed = 300
var health = 5
@onready var image = get_node("creature_current_design")

# Called when the node enters the scene tree for the first time.
func _ready():
	image.speed_up.connect(speed_up)

func _process(_delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	move_and_slide()
	
func speed_up():
	speed = 500

func hit():
	health = health - 1
	print("Hit!")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") and get_tree().current_scene.name == "first_fight":
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = position + Vector2(40.0, 0.0) # Sets position 
		bullet.rotation = rotation
		bullet.apply_scale(Vector2(2, 2)) # Sets scale of bullet, <1,1> is original size
		return
