extends Node



## The scene used for instantiated always-on-top windows.
@export var window_scene : PackedScene

@onready var selected_container : Panel = $MarginContainer/Control/Panel
@onready var selected_texture : TextureRect = $MarginContainer/Control/Panel/MarginContainer/Selected



## Detect file drops.
func _ready():
	get_viewport().files_dropped.connect(on_files_dropped)
	get_window().min_size = Vector2i(530, 245)

## Handle dropped files.
func on_files_dropped(files : PackedStringArray) -> void:
	for file in files: create_window(file)

## Create a window and insert the given file.
func create_window(file : String) -> void:
	var texture : Texture

	match file.right(file.length() - file.rfind(".") - 1):
		"bmp", "dds", "exr", "hdr", "jpg", "jpeg", "png", "tga", "svg", "webp":
			var image : Image = Image.load_from_file(file)
			if image.is_empty(): return # Ignore if it can't load the image.
			texture = ImageTexture.create_from_image(image)
		"gif":
			texture = GifManager.animated_texture_from_file(file)
		_:
			return

	if !texture: return
	var new_window : Window = window_scene.instantiate()
	new_window.name = file.right(file.length() - file.rfind("\\") - 1)

	new_window.set_image(texture)

	self.add_child(new_window)



func duplicate_window(window : Window) -> void:
	var new_window : Window = window_scene.instantiate()
	new_window.name = window.name+"duplicate"
	new_window.set_image(window.get_image())
	self.add_child(new_window)
	new_window.size = window.size
	new_window.position = window.position + Vector2i(15, 15)
