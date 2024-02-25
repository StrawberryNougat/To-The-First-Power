extends MarginContainer

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://pitstop_scenes/opening_pitstop.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://UI/credits.tscn")
