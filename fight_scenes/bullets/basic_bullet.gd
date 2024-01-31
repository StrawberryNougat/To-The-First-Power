extends Node2D

const speed = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta

#if this stops working again try to connect the signal with code
func _on_area_2d_body_entered(body):
	print("hit")
	if body.has_method("hit"):
		body.hit()
	queue_free() # Replace with function body.
