extends Sprite2D

var current_build = load("res://Sprites/candidate_sprites/initial_creature.png")
signal speed_up
signal strength_up
signal visible_hitbox
signal more_health
signal smaller_hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	var dialogue_cond = get_node("/root/dialogue_conditions")
	dialogue_cond.chose_strength.connect(change_to_str)
	dialogue_cond.chose_agility.connect(change_to_spd)
	dialogue_cond.chose_visible_hitbox.connect(change_to_vis_h)
	dialogue_cond.chose_more_health.connect(change_to_more_health)
	dialogue_cond.chose_smaller_hitbox.connect(change_to_sm_hb)
	set_process_input(true) # Replace with function body.
	texture = current_build

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_to_str():
	current_build = load("res://Sprites/candidate_sprites/creature_pink.png")
	#current_build.resize(100,100,1)
	texture = current_build
	emit_signal("strength_up")
	
func change_to_spd():
	current_build = load("res://Sprites/candidate_sprites/to_the_first_power_speedup.png")
	texture = current_build
	emit_signal("speed_up")

func change_to_vis_h():
	current_build = load("res://Sprites/candidate_sprites/initial_creature.png")
	texture = current_build
	emit_signal("visible_hitbox")
	
func change_to_more_health():
	current_build = load("res://Sprites/candidate_sprites/initial_creature.png") #Uncomment when sprite is made
	texture = current_build
	emit_signal("more_health")

func change_to_sm_hb():
	current_build = load("res://Sprites/candidate_sprites/initial_creature.png") #Uncomment when sprite is made
	texture = current_build
	emit_signal("smaller_hitbox")
