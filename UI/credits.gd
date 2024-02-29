extends Node2D
var text
var speed = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	text = $Control/RichTextLabel
	text.text = "[center]%s[/center]" % text.text
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text.position -= transform.y*speed*delta


func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
	#pass # Replace with function body.
