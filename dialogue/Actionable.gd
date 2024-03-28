extends Area2D


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "Guide"

func action():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	
