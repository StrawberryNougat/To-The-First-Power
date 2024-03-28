extends Node

var opening_choice = ""
signal chose_strength
signal chose_agility
signal chose_visible_hitbox

var second_choice = ""
signal chose_more_health
signal chose_smaller_hitbox



func _process(_delta):
	#First pitstop choices
	if (opening_choice == "strength"):
		emit_signal("chose_strength")
	elif (opening_choice == "speed"):
		emit_signal("chose_agility")
	elif (opening_choice == "vis_hitbox"):
		emit_signal("chose_visible_hitbox")
	
	#Second pitstop choices
	if (second_choice == "more_health"):
		emit_signal("chose_more_health")
	elif (second_choice == "smaller_hitbox"):
		emit_signal("chose_smaller_hitbox")
