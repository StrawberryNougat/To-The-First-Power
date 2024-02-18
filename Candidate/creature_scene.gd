extends CharacterBody2D

signal creature_dead()

const bullet_scene = preload("res://fight_scenes/bullets/basic_bullet.tscn")
var current_form
var speed = 300
var bullet_scale = Vector2(2.0,2.0)
var bullet_offset = Vector2(40.0,0)
var health = 5
var invincible = false
var timer 
var paused = false

#This is because of the continuous signal emitting to check that health only goes up once
var moreHealth = false

@onready var image = get_node("creature_current_design")
@onready var collider = get_node("CollisionShape2D")
@onready var hitbox = get_node("hitbox")
@onready var pauseMenu = get_node("Node2D/PauseMenu")


# Called when the node enters the scene tree for the first time.
func _ready():
	image.speed_up.connect(speed_up)
	image.strength_up.connect(strength_up)
	image.visible_hitbox.connect(visible_hitbox)
	image.more_health.connect(more_health)
	

	#create timer node on entering scene tree and set timer conditions
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = .5
	timer.one_shot = true
	timer.autostart = false
	timer.timeout.connect(_on_timer_timeout)


func _process(_delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	move_and_slide()


func speed_up():
	if Input.is_action_pressed("Sprint") && speed == 300:
		speed = 500
	elif !Input.is_action_pressed("Sprint") && speed == 500:
		speed = 300
	hitbox.visible = false


func strength_up():
	speed = 300
	hitbox.visible = false
	bullet_scale = Vector2(4.0,4.0)
	bullet_offset = Vector2(80,0)
	collider.scale = Vector2(1.7,1.7)


func visible_hitbox():
	speed = 300
	hitbox.visible = true


func more_health():
	if (!moreHealth):
		health = health + 3
		moreHealth = true
	else:
		health = health


func hit():
	if !invincible:
		health = health - 1
		print("Hit!")
		invincible = true 
		timer.start()
	else:
		health = health
		#print("Nope!")
	#If anyone is listening, the current creature is indeed dead.
	if health <= 0:
		emit_signal("creature_dead")
	
func _on_timer_timeout():
	invincible = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact") and get_tree().current_scene.name == "first_fight":
		# Instantiate bullet and add it to scene
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		
		# Set bullet position, rotation, and scale
		# NOTE: position is offset to not instantiate in the CollisionShape2D of the creature
		# Currently, this is hard-coded, but once I figure out how to not do it this way I will fix it
		bullet.position = position + bullet_offset
		bullet.rotation = rotation
		bullet.apply_scale(bullet_scale)
		return


func _on_pause_menu_pause():
	pauseMenu.Pause()


func _on_pause_menu_resume():
	pauseMenu.Resume()


func _on_pause_menu_clearout():
	pass
