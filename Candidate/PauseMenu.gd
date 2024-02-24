extends Panel

signal pause
signal resume

var paused = false
var form
var sfx 


func _ready():
	form = get_node("/root/dialogue_conditions")
	sfx = get_node("shoot_sfx")

func _process(delta):
	if Input.is_action_just_pressed("Pause") && !paused:
		emit_signal("pause")
	elif Input.is_action_just_pressed("Pause") && paused:
		emit_signal("resume")

func Pause():
	get_tree().paused = true
	paused = true
	show()


func Resume():
	hide()
	paused = false
	get_tree().paused = false


func _on_main_menu_pressed():
	get_tree().paused = false
	form.opening_choice = ""
	form.second_choice = ""
	get_tree().call_group("bullets", "queue_free")
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")


func _on_last_pit_stop_pressed():
	if get_tree().current_scene.name == "first_fight" || get_tree().current_scene.name == "opening_pitstop":
		form.opening_choice = ""
		get_tree().paused = false
		get_tree().call_group("bullets", "queue_free")
		get_tree().change_scene_to_file("res://pitstop_scenes/opening_pitstop.tscn")
		
	elif get_tree().current_scene.name == "second_pitstop" || get_tree().current_scene.name == "second_fight" || get_tree().current_scene.name == "ending":
		form.second_choice = ""
		get_tree().paused = false
		get_tree().call_group("bullets", "queue_free")
		get_tree().change_scene_to_file("res://pitstop_scenes/second_pitstop.tscn")


func _on_resume_pressed():
	Resume()


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	#pass # Replace with function body.
