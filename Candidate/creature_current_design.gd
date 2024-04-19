extends Sprite2D

var current_build = load("res://Sprites/candidate_sprites/initial_creature.png")
var attacking
signal speed_up
signal strength_up
signal visible_hitbox
signal more_health
signal smaller_hitbox
var attacking_sprite = load("res://Sprites/candidate_sprites/initial_creature.png")
@onready var change_form_sfx = $change_form_sfx
@onready var animation_timer = $animation_timer

var bool_speed

var bool_vis

var bool_str

var bool_smol

var bool_health


# Called when the node enters the scene tree for the first time.
func _ready():
	texture = current_build
	var dialogue_cond = get_node("/root/dialogue_conditions")
	dialogue_cond.chose_strength.connect(change_to_str)
	dialogue_cond.chose_agility.connect(change_to_spd)
	dialogue_cond.chose_visible_hitbox.connect(change_to_vis_h)
	dialogue_cond.chose_more_health.connect(change_to_more_health)
	dialogue_cond.chose_smaller_hitbox.connect(change_to_sm_hb)
	bool_speed = false
	bool_vis = false
	bool_str = false
	bool_smol = false
	bool_health = false
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and (get_tree().current_scene.name == "first_fight" or get_tree().current_scene.name == "second_fight"):
		texture = attacking_sprite
		animation_timer.start()
		
		

func change_to_str():
	current_build = load("res://Sprites/candidate_sprites/power.png")
	attacking_sprite = load("res://Sprites/candidate_sprites/power_shoot.png")
	#current_build.resize(100,100,1)
	if (!bool_str):
		texture = current_build
		bool_speed = false
		bool_vis = false
		bool_str = true
		bool_smol = false
		bool_health = false
	emit_signal("strength_up")
	
func change_to_spd():
	current_build = load("res://Sprites/candidate_sprites/to_the_first_power_speedup.png")
	attacking_sprite = load("res://Sprites/candidate_sprites/to_the_first_power_speedup_attack.png")
	#texture = current_build
	#texture = current_build
	if (!bool_speed):
		texture = current_build
		bool_speed = true
		bool_vis = false
		bool_str = false
		bool_smol = false
		bool_health = false
	emit_signal("speed_up")

func change_to_vis_h():
	current_build = load("res://Sprites/candidate_sprites/visHitbox.png")
	attacking_sprite = load("res://Sprites/candidate_sprites/visHitboxAttack.png")
	if (!bool_vis):
		texture = current_build
		bool_speed = false
		bool_vis = true
		bool_str = false
		bool_smol = false
		bool_health = false
	#texture = current_build
	#texture = current_build
	emit_signal("visible_hitbox")
	
func change_to_more_health():
	if (current_build == load("res://Sprites/candidate_sprites/visHitbox.png")):
		current_build = load("res://Sprites/candidate_sprites/visHB_MHealth.png")
		attacking_sprite = load("res://Sprites/candidate_sprites/visHB_MHealthAttack.png")
	if (current_build == load("res://Sprites/candidate_sprites/to_the_first_power_speedup.png")):
		current_build = load("res://Sprites/candidate_sprites/boi.png") #Uncomment when sprite is made
		attacking_sprite = load("res://Sprites/candidate_sprites/boiAttack.png")
	if (current_build == load("res://Sprites/candidate_sprites/power.png")):
		current_build = load("res://Sprites/candidate_sprites/Extra_HealthNormal.png") #Uncomment when sprite is made
		attacking_sprite = load("res://Sprites/candidate_sprites/Extra_Health.png")
	if (!bool_health):
		texture = current_build
		bool_speed = false
		bool_vis = false
		bool_str = false
		bool_smol = false
		bool_health = true
	#texture = current_build
	#texture = current_build
	emit_signal("more_health")

func change_to_sm_hb():
	#current_build = load("res://Sprites/candidate_sprites/initial_creature.png") #Uncomment when sprite is made
	if (current_build == load("res://Sprites/candidate_sprites/visHitbox.png")):
		current_build = load("res://Sprites/candidate_sprites/visHitbox_smallHitbox.png")
		attacking_sprite = load("res://Sprites/candidate_sprites/vHB_smHBAttack.png")
	if (current_build == load("res://Sprites/candidate_sprites/to_the_first_power_speedup.png")):
		current_build = load("res://Sprites/candidate_sprites/kangoRat.png") #Uncomment when sprite is made
		attacking_sprite = load("res://Sprites/candidate_sprites/kangoRatAttack.png")
	if (current_build == load("res://Sprites/candidate_sprites/power.png")):
		current_build = load("res://Sprites/candidate_sprites/hitboxnormal.png") #Uncomment when sprite is made
		attacking_sprite = load("res://Sprites/candidate_sprites/hitboxshoot.png")
	#if (not (get_tree().current_scene.name == "first_fight" or get_tree().current_scene.name == "second_fight")):
		#texture = current_build
	if (!bool_smol):
		texture = current_build
		bool_speed = false
		bool_vis = false
		bool_str = false
		bool_smol = true
		bool_health = false
	
	
	
		
	#texture = current_build
	emit_signal("smaller_hitbox")



	


func _on_animation_timer_timeout():
	texture = current_build # Replace with function body.
