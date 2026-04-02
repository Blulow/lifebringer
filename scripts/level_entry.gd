extends Node2D

@onready var camera := $Camera2D
@onready var level_entries := $LevelEntries.get_children()
@onready var pointer := $Pointer
@onready var selector := $Selector

var current_level: int
var selected_level := 1

var pulse_dir := -1

func _ready() -> void:
	current_level = GameState.current_level
	load_level_ui(current_level)
	load_path_anim(current_level)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if !GameState.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			GameState.fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			GameState.fullscreen = false
	
	if Input.is_action_pressed("up"):
		if camera.position.y > -504:
			camera.position.y -= 8
	elif Input.is_action_pressed("down"):
		if camera.position.y < 0:
			camera.position.y += 8
	
	if Input.is_action_just_pressed("left"):
		select(-1)
	if Input.is_action_just_pressed("right"):
		select(1)
	
	if Input.is_action_just_pressed("confirm"):
		get_tree().change_scene_to_file("res://scenes/fight_scene.tscn")
	
	selector.modulate.a += pulse_dir * 0.01
	if selector.modulate.a <= 0:
		pulse_dir = 1
	elif selector.modulate.a >= 0.5:
		pulse_dir = -1

func load_level_ui(level: int):
	if level == 2:
		level_entries[1].visible = true
	elif level == 3:
		level_entries[1].visible = true
		level_entries[2].visible = true
	pointer.global_position = level_entries[level - 1].get_node("Sprite2D").global_position + Vector2(-282, -419)

func load_path_anim(level: int):
	var paths := level_entries[level - 1].get_node("Paths")
	if not paths:
		return
	for i in paths.get_children():
		i.visible = false
	for i in paths.get_children():
		i.visible = true
		await get_tree().create_timer(0.5).timeout

func select(dir: int):
	if selected_level + dir >= 1 and selected_level + dir <= current_level:
		selected_level += dir
		selector.global_position = level_entries[selected_level - 1].get_node("Sprite2D").global_position + Vector2(-282, -419)
