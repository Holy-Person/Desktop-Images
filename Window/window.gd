extends Window



var drag_offset : Vector2i



## Update window with new image.
func set_image(image : ImageTexture) -> void:
	$TextureRect.texture = image
	size = image.get_size()
func get_image() -> ImageTexture:
	return $TextureRect.texture



func _input(event : InputEvent) -> void:
	# Set offset on drag start.
	if Input.is_action_just_pressed(&"drag"):
		drag_offset = event.position
	# Dragging.
	if event is InputEventMouseMotion and Input.is_action_pressed(&"drag"):
		position += Vector2i(event.global_position) - drag_offset

	# Keybinds.
	if Input.is_action_just_pressed(&"close"):
		get_parent().get_window().grab_focus()
		self.queue_free()
	elif Input.is_action_just_pressed(&"grow"):
		size *= 1.1
	elif Input.is_action_just_pressed(&"shrink"):
		size /= 1.1
	elif Input.is_action_just_pressed(&"home"):
		get_parent().get_window().grab_focus()
	elif Input.is_action_just_pressed(&"duplicate"):
		get_parent().duplicate_window(self)
	elif Input.is_action_just_pressed(&"flip_v"):
		$TextureRect.flip_v = !$TextureRect.flip_v
	elif Input.is_action_just_pressed(&"flip_h"):
		$TextureRect.flip_h = !$TextureRect.flip_h
