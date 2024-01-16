extends Node

var opening_choice = ""
signal chose_strength
signal chose_agility

func _process(_delta):
	if (opening_choice == "strength"):
		emit_signal("chose_strength")
	elif (opening_choice == "speed"):
		emit_signal("chose_agility")
