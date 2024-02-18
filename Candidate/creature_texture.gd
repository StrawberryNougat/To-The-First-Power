class_name CreatureTexture
extends Node2D

#Just make it easier to create a new texture.
func _init(new_text:Node2D = null) -> void:
	texture_node = new_text
	
## This will be the texture node for the specific character.
## It is allowed to be either a Node2D or a AnimatedSprite2D
## or whatever else we add support for in the future.
var texture_node:Node2D:
	set(new_texture_node):
		if new_texture_node is Sprite2D or new_texture_node is AnimatedSprite2D:
			texture_node.queue_free()
			texture_node = new_texture_node
		else:
			push_error("Unsupported texture type")
			
## This variable hold the size of the texture (for use in hitboxes etc)
## This currently only supports Sprite2D and AnimatedSprite2D.
var size:Vector2:
	get:
		if texture_node == null:
			assert(false,"texture_node not set yet.")
			# Returns this on live build just in case, but will never hit this
			# In debug.
			return Vector2(10,10)
		if texture_node is Sprite2D:
			return texture_node.texture.get_size()
		elif texture_node is AnimatedSprite2D:
			return texture_node.sprite_frames.get_frame_texture(texture_node.animation,0).get_size()
		else:
			assert(false, "You have a unsupported node type so we cant find the size.")
			return Vector2(10,10)
