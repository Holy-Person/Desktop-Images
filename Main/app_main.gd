extends Node



## The scene used for instantiated always-on-top windows.
@export var window_scene : PackedScene

@onready var selected_container : Panel = $MarginContainer/Control/Panel
@onready var selected_texture : TextureRect = $MarginContainer/Control/Panel/MarginContainer/Selected

var are_windows_focusable : bool = true



## Detect file drops.
func _ready():
	get_viewport().files_dropped.connect(on_files_dropped)

## Handle dropped files.
func on_files_dropped(files : PackedStringArray) -> void:
	for file in files: create_window(file)

## Create a window and insert the given file.
func create_window(file : String) -> void:
	var image = Image.new()
	image.load(file)

	if image.is_empty(): return # Ignore if it can't load the image.

	var new_window : Window = window_scene.instantiate()
	new_window.name = file.right(file.length() - file.rfind("\\") - 1)

	var texture = ImageTexture.create_from_image(image)
	new_window.set_image(texture)

#	new_window.focus_entered.connect(window_focused.bind(new_window))
#	new_window.tree_exiting.connect(window_focused)

	self.add_child(new_window)

## Unfinished functionality, shows a preview of the currently selected window.
#func window_focused(window : Window = null) -> void:
#	if !window:
#		selected_texture.texture = null
#		return
#	var window_image : ImageTexture = window.get_image()
#	selected_texture.texture = window_image
#	selected_container.custom_minimum_size = window_image.get_size() / ( window_image.get_size() - Vector2(150, 150) )



func duplicate_window(window : Window) -> void:
	var new_window : Window = window_scene.instantiate()
	new_window.name = window.name+"duplicate"
	new_window.set_image(window.get_image())
	self.add_child(new_window)
	new_window.size = window.size
	new_window.position = window.position + Vector2i(15, 15)
