extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_exit_body_entered(body):
	print("going...")#pass # Replace with function body.
	get_tree().change_scene_to_file("res://fight_scenes/first_fight.tscn")
