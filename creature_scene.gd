extends CharacterBody2D

var current_form
var speed = 300
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
	print("Hit!")
