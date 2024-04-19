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


# Called when the node enters the scene tree for the first time.
func _ready():
	var dialogue_cond = get_node("/root/dialogue_conditions")
	dialogue_cond.chose_strength.connect(change_to_str)
	dialogue_cond.chose_agility.connect(change_to_spd)
	dialogue_cond.chose_visible_hitbox.connect(change_to_vis_h)
	dialogue_cond.chose_more_health.connect(change_to_more_health)
	dialogue_cond.chose_smaller_hitbox.connect(change_to_sm_hb)
	attacking = false
	set_process_input(true) # Replace with function body.
	#texture = current_build

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	texture = current_build
	if Input.is_action_just_pressed("interact") and (get_tree().current_scene.name == "first_fight" or get_tree().current_scene.name == "second_fight"):
		texture = attacking_sprite
		
		

func change_to_str():
	current_build = load("res://Sprites/candidate_sprites/power.png")
	attacking_sprite = load("res://Sprites/candidate_sprites/power_shoot.png")
	#current_build.resize(100,100,1)
	#texture = current_build
	emit_signal("strength_up")
	
func change_to_spd():
	current_build = load("res://Sprites/candidate_sprites/to_the_first_power_speedup.png")
	attacking_sprite = load("res://Sprites/candidate_sprites/to_the_first_power_speedup_attack.png")
	#texture = current_build
	emit_signal("speed_up")

func change_to_vis_h():
	current_build = load("res://Sprites/candidate_sprites/visHitbox.png")
	attacking_sprite = load("res://Sprites/candidate_sprites/visHitboxAttack.png")
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
	#texture = current_build
	emit_signal("more_health")

func change_to_sm_hb():
	#current_build = load("res://Sprites/candidate_sprites/initial_creature.png") #Uncomment when sprite is made
	if (current_build == load("res://Sprites/candidate_sprites/visHitbox.png")):
		current_build = load("res://Sprites/candidate_sprites/visHitbox_smallHitbox.png")
		attacking_sprite = load("res://Sprites/candidate_sprites/visHitbox_smallHitbox.png")
	if (current_build == load("res://Sprites/candidate_sprites/to_the_first_power_speedup.png")):
		current_build = load("res://Sprites/candidate_sprites/kangoRat.png") #Uncomment when sprite is made
		attacking_sprite = load("res://Sprites/candidate_sprites/kangoRatAttack.png")
	if (current_build == load("res://Sprites/candidate_sprites/power.png")):
		current_build = load("res://Sprites/candidate_sprites/hitboxnormal.png") #Uncomment when sprite is made
		attacking_sprite = load("res://Sprites/candidate_sprites/hitboxshoot.png")
	
		
	#texture = current_build
	emit_signal("smaller_hitbox")



	
