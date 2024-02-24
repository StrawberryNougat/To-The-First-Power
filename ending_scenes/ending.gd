extends Node2D

var form
# Called when the node enters the scene tree for the first time.
func _ready():
	form = get_node("/root/dialogue_conditions")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_body_entered(body):
	print("going to credits...")#pass # Replace with function body.
	form.opening_choice = ""
	form.second_choice = ""
	#reset creature powers before restarting game
	get_tree().change_scene_to_file("res://UI/credits.tscn")
