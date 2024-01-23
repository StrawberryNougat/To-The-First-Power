extends CharacterBody2D

var current_form
var speed = 300
var health = 5
var invincible = false
var timer 
@onready var image = get_node("creature_current_design")

# Called when the node enters the scene tree for the first time.
func _ready():
	image.speed_up.connect(speed_up)
	
	#create timer node on entering scene tree and set timer conditions
	var newtimer = Timer.new()
	add_child(newtimer)
	newtimer.wait_time = .5
	newtimer.one_shot = true
	newtimer.autostart = false
	newtimer.timeout.connect(_on_timer_timeout)

func _process(_delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	move_and_slide()
	
func speed_up():
	speed = 500

func hit():
	if !invincible:
		health = health - 1
		print("Hit!")
		invincible = true
		timer.start(.5)
	else:
		health = health
	
func _on_timer_timeout():
	invincible = false
