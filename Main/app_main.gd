extends Node



## The scene used for instantiated always-on-top windows.
@export var window_scene : PackedScene

@onready var selected_container : Panel = $MarginContainer/Control/Panel
@onready var selected_texture : TextureRect = $MarginContainer/Control/Panel/MarginContainer/Selected
@onready var version: Label = %Version



## Detect file drops.
func _ready():
	get_viewport().files_dropped.connect(on_files_dropped)
	get_window().min_size = Vector2i(530, 245)
	version.text = "v"+ProjectSettings.get_setting("application/config/version")

## Handle dropped files.
func on_files_dropped(files : PackedStringArray) -> void:
	for file in files: parse_data(file)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_V && event.ctrl_pressed:
			paste_content()

## Create a window and insert the given file.
func parse_data(data) -> void:
	if data is String:
		var filepath : String = data
		var texture : Texture

		match filepath.right(filepath.length() - filepath.rfind(".") - 1):
			"bmp", "dds", "exr", "hdr", "jpg", "jpeg", "png", "tga", "svg", "webp":
				var image : Image = Image.load_from_file(filepath)
				if image.is_empty(): return # Ignore if it can't load the image.
				texture = ImageTexture.create_from_image(image)
			"gif":
				texture = GifManager.animated_texture_from_file(filepath)
			_:
				return
		create_window(texture)

	elif data is Image:
		var texture : Texture = ImageTexture.create_from_image(data)
		create_window(texture)

func create_window(texture : Texture) -> void:
	if !texture: return
	var new_window : Window = window_scene.instantiate()
	#new_window.name = file.right(file.length() - file.rfind("\\") - 1)

	new_window.set_image(texture)

	self.add_child(new_window)

func paste_content() -> void:
	var clipboard_content
	if DisplayServer.clipboard_has_image():
		clipboard_content = DisplayServer.clipboard_get_image()
	else:
		clipboard_content = DisplayServer.clipboard_get().replace('"', '')
	parse_data(clipboard_content)

func duplicate_window(window : Window) -> void:
	var new_window : Window = window_scene.instantiate()
	new_window.name = window.name+"duplicate"
	new_window.set_image(window.get_image())
	self.add_child(new_window)
	new_window.size = window.size
	new_window.position = window.position + Vector2i(15, 15)
