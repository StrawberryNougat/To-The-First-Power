extends Node2D

@onready var canidate = get_node("Creature_Scene")
@onready var enemy = get_node("second_enemy")

# Called when the node enters the scene tree for the first time.
func _ready():
	canidate.creature_dead.connect(player_creature_dead)
	enemy.enemy_dead.connect(enemy_is_dead)
	$exit/CollisionShape2D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Canidate_health.text = "Health: %s" % str(canidate.health)
	$Enemy_Health.text = "Enemy HP: %s" % str(enemy.enemy_health)

func _on_exit_body_entered(body):
	#will go to 'ending'
	print("going to ending scene...")
	get_tree().change_scene_to_file("res://ending_scenes/ending.tscn")
	
func player_creature_dead() -> void:
	enemy.on_exit_fight()
	get_tree().change_scene_to_file("res://pitstop_scenes/second_pitstop.tscn")
	

func enemy_is_dead() -> void:
	$Enemy_Health.visible = false
	remove_child(enemy)
	$exit/CollisionShape2D.call_deferred("set_disabled",false)
	
