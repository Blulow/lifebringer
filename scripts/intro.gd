extends Node2D

@onready var continue_button := $CanvasLayer/Continue

var typing_speed := 20
var current_scene_index := 0
var pulse_dir := -1
var shake_intensity := 20.0
var shake_decay := 5.0
var shaking := false

@onready var scenes := [$CanvasLayer/IntroScene1, $CanvasLayer/IntroScene2, $CanvasLayer/IntroScene3, $CanvasLayer/IntroScene4, $CanvasLayer/IntroScene5, $CanvasLayer/IntroScene6]

func _ready() -> void:
	open_scene(scenes[current_scene_index])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if !GameState.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			GameState.fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			GameState.fullscreen = false
	
	if continue_button.visible:
		if Input.is_action_just_pressed("confirm"):
			if current_scene_index < scenes.size():
				close_scene(scenes[current_scene_index - 1])
				open_scene(scenes[current_scene_index])
			else:
				get_tree().change_scene_to_file("res://scenes/level_entry.tscn")
	
	pulse_continue()
	
	if shaking:
		if shake_intensity > 0:
			shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta)
			$CanvasLayer.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		else:
			$CanvasLayer.offset = lerp($CanvasLayer.offset, Vector2.ZERO, 10 * delta)

func open_scene(scene: Node2D):
	continue_button.visible = false
	
	scene.visible = true
	if scene.get_node("RichTextLabel"):
		show_dialogue(scene.get_node("RichTextLabel"))
	elif scene == scenes[4]:
		boom(scene)
	
	if current_scene_index < 6:
		current_scene_index += 1

func close_scene(scene: Node2D):
	scene.visible = false
	continue_button.visible = false

func show_dialogue(label: RichTextLabel) -> void:
	label.visible_characters = 0

	var parsed_text := label.get_parsed_text()
	var total := parsed_text.length()

	while label.visible_characters < total:
		label.visible_characters += 1

		var char := parsed_text[label.visible_characters - 1]
		var delay := get_char_delay(char)

		await get_tree().create_timer(delay).timeout
	await get_tree().create_timer(1.0).timeout
	continue_button.visible = true

func get_char_delay(char: String) -> float:
	match char:
		" ":
			return 0.01
		".", "!", "?":
			return 0.35
		",":
			return 0.2
		"\n":
			return 0.1
		_:
			return 1.0 / typing_speed
	

func pulse_continue():
	if continue_button.modulate.a <= 0:
		pulse_dir = 1
	elif continue_button.modulate.a >= 1:
		pulse_dir = -1
	continue_button.modulate.a += pulse_dir * 0.01

func boom(scene: Node2D):
	if not scene == scenes[4]:
		return
		
	await get_tree().create_timer(0.5).timeout
	shaking = true
	scene.get_node("Sprite2D").visible = false
	await get_tree().create_timer(1.0).timeout
	shaking = false
	continue_button.visible = true
