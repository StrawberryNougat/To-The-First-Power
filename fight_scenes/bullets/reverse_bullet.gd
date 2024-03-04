extends VisibleOnScreenNotifier2D
var cur_speed = 100
var speed = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	cur_speed = speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * cur_speed * delta
	cur_speed -= delta * (speed / 5)
	if (cur_speed < -speed):
		cur_speed = -speed

#if this stops working again try to connect the signal with code
func _on_area_2d_body_entered(body):
	#print("hit")
	if body.has_method("hit_player"):
		body.hit_player()
	queue_free() # Replace with function body.

func _on_screen_exited() -> void:
	queue_free()
