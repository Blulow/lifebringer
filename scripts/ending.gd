extends Node2D

signal boom

var typing_speed := 5
var show_ending := false
var title_screen := false
var shake_intensity := 20.0
var shake_decay := 5.0
var shaking := false
var fade_in := false
var fade_out := false
var boomed := false

func _ready() -> void:
	show_dialogue($RichTextLabel)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if !GameState.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			GameState.fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			GameState.fullscreen = false
	
	if $RichTextLabel.visible_ratio == 1:
		await get_tree().create_timer(2.0).timeout
		$RichTextLabel.visible = false
		await get_tree().create_timer(2.0).timeout
		reverse_boom()
		if fade_out:
			typing_speed = 20
	if $RichTextLabel2.visible_ratio == 1 and fade_out:
		await get_tree().create_timer(2.0).timeout
		if $Camera2D.position.y < 648:
			$Camera2D.position.y += 0.5
	
	if fade_in:
		$CanvasLayer/TextureRect.modulate.a += 0.1
		if $CanvasLayer/TextureRect.modulate.a >= 1 and not boomed:
			await get_tree().create_timer(2.0).timeout
			boomed = true
			boom.emit()
	if fade_out:
		$CanvasLayer/TextureRect2.modulate.a -= 0.1
	
	if shaking:
		if shake_intensity > 0:
			shake_intensity = lerp(shake_intensity, 0.0, shake_decay * delta)
			$CanvasLayer.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		else:
			$CanvasLayer.offset = lerp($CanvasLayer.offset, Vector2.ZERO, 10 * delta)

func show_dialogue(label: RichTextLabel) -> void:
	label.visible_characters = 0

	var parsed_text := label.get_parsed_text()
	var total := parsed_text.length()

	while label.visible_characters < total:
		label.visible_characters += 1

		var char := parsed_text[label.visible_characters - 1]
		var delay := get_char_delay(char)

		await get_tree().create_timer(delay).timeout

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

func reverse_boom():
	if boomed:
		return
	$CanvasLayer/TextureRect.visible = true
	if not fade_in:
		$CanvasLayer/TextureRect.modulate.a = 0.0
	fade_in = true
	await boom
	shaking = true
	$CanvasLayer/TextureRect.visible = false
	$CanvasLayer/TextureRect2.visible = true
	await get_tree().create_timer(2.0).timeout
	fade_out = true
	await get_tree().create_timer(2.0).timeout
	if not show_ending and fade_out:
		$CanvasLayer/TextureRect2.visible = false
		show_dialogue($RichTextLabel2)
		show_ending = true
