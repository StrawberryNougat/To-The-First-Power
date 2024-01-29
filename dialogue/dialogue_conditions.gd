extends Node

var opening_choice = ""
signal chose_strength
signal chose_agility
signal chose_visible_hitbox

func _process(_delta):
	if (opening_choice == "strength"):
		emit_signal("chose_strength")
	elif (opening_choice == "speed"):
		emit_signal("chose_agility")
	elif (opening_choice == "vis_hitbox"):
		emit_signal("chose_visible_hitbox")
