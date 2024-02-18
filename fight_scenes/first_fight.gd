extends Node2D

@onready var canidate = get_node("Creature_Scene")
@onready var enemy = get_node("first_enemy")

# Called when the node enters the scene tree for the first time.
func _ready():
	canidate.creature_dead.connect(player_creature_dead)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Canidate_health.text = "Health: %s" % str(canidate.health)
	$Enemy_Health.text = "Enemy HP: %s" % str(enemy.enemy_health)

func _on_exit_body_entered(body):
	print("going to pitstop 2...")
	enemy.on_exit_fight()
	get_tree().change_scene_to_file("res://pitstop_scenes/second_pitstop.tscn")
	
func player_creature_dead():
	enemy.on_exit_fight()
	get_tree().change_scene_to_file("res://pitstop_scenes/opening_pitstop.tscn")
