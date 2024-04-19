extends CharacterBody2D

signal creature_dead()

const bullet_scene = preload("res://fight_scenes/bullets/player_bullet.tscn")
var current_form
var speed = 300
var bullet_scale = Vector2(2.0,2.0)
var bullet_offset = Vector2(40.0,0)
var health = 5
var invincible = false
var timer 
var paused = false


#This is because of the continuous signal emitting to check that health only goes up once
var vis_hitbox = false
var moreHealth = false
var sm_hb = false

@onready var image = get_node("creature_current_design")
@onready var collider = get_node("CollisionShape2D")
@onready var hitbox = get_node("hitbox")
@onready var pauseMenu = get_node("Node2D/PauseMenu")
@onready var animation = get_node("creature_current_design/shoot_animation")
@onready var animation2 = get_node("creature_current_design/shoot_animation_2")
@onready var shoot_sfx = get_node("Node2D/PauseMenu/shoot_sfx")
@onready var current_design = get_node("creature_current_design")
@onready var shoot_timer = $shoot_timer

var current_animation

var phase_2_active

var current_animation_2

var can_shoot


# Called when the node enters the scene tree for the first time.
func _ready():
	image.speed_up.connect(speed_up)
	image.strength_up.connect(strength_up)
	image.visible_hitbox.connect(visible_hitbox)
	image.more_health.connect(more_health)
	image.smaller_hitbox.connect(smaller_hitbox)

	#animation.stop()
	

	#create timer node on entering scene tree and set timer conditions
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.autostart = false
	timer.timeout.connect(_on_timer_timeout)
	current_animation = null
	current_animation_2 = null
	phase_2_active = false
	can_shoot = true
	
	


func _process(_delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	if(!Global.in_dialogue):
		move_and_slide()
#


func speed_up():
	#animation.stop()
	#animation.play("speed_idle")
	if Input.is_action_pressed("Sprint") && speed == 300:
		speed = 500
	elif !Input.is_action_pressed("Sprint") && speed == 500:
		speed = 300
	current_animation = "speed_ani"
	hitbox.visible = false


func strength_up():
	speed = 300
	hitbox.visible = false
	bullet_scale = Vector2(4.0,4.0)
	bullet_offset = Vector2(80,0)
	collider.scale = Vector2(1.7,1.7)
	current_animation = null


func visible_hitbox():
	if (!vis_hitbox):
		speed = 300
		hitbox.visible = true
		vis_hitbox = true
	current_animation = "vis_hit_ani"


func more_health():
	phase_2_active = true
	if (!moreHealth):
		health = health*2
		moreHealth = true
	else:
		health = health
	if (current_animation == "speed_ani"):
		current_animation_2 = "speed_health_ani"

func smaller_hitbox():
	phase_2_active = true
	if (!sm_hb):
		collider.scale /= 4
		hitbox.scale /= 4
		if (vis_hitbox):
			current_animation_2 = "vis_small_ani"
			hitbox.visible = true
		sm_hb = true
	#current_animation = null

func hit_player():
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
	if Input.is_action_pressed("interact") and (get_tree().current_scene.name == "first_fight" or get_tree().current_scene.name == "second_fight") and can_shoot:
		# Instantiate bullet and add it to scene
		
		#if (current_animation != null && !phase_2_active):
			#animation.visible = true
			#animation.play(current_animation)
		#if (current_animation_2 != null && phase_2_active):
			#animation2.visible = true
			#animation2.play(current_animation_2)
		
		#current_design.texture = current_design.attacking_sprite
		can_shoot = false
		
		shoot_sfx.play()
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.add_to_group("bullets")
		# Set bullet position, rotation, and scale
		# NOTE: position is offset to not instantiate in the CollisionShape2D of the creature
		# Currently, this is hard-coded, but once I figure out how to not do it this way I will fix it
		bullet.position = position + bullet_offset
		bullet.rotation = rotation
		bullet.apply_scale(bullet_scale)
		
		
		shoot_timer.start()
		
		#current_design.texture = current_design.current_build
		#animation.visible = false
		return


func _on_pause_menu_pause():
	pauseMenu.Pause()


func _on_pause_menu_resume():
	pauseMenu.Resume()


func _on_shoot_timer_timeout():
	can_shoot = true # Replace with function body.

