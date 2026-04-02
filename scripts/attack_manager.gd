extends Node2D

var level_movement := preload("res://assets/resources/levels/level_movement.tres")
var level_collision := preload("res://assets/resources/levels/level_collision.tres")
var level_time := preload("res://assets/resources/levels/level_time.tres")

signal start(song, events)

@onready var rhythm_controller_scene := $"../RhythmController"

var current_bullet_mechanic : Node2D
var current_player_mechanic : Node2D

var bullet_mechanics = {
	"teleporting_attack": preload("res://scenes/bullet_mechanics/teleporting_attack.tscn"),
	"movement_sequence": preload("res://scenes/bullet_mechanics/movement_sequence.tscn"),
	"black_hole": preload("res://scenes/bullet_mechanics/black_hole.tscn"),
	"falling_bullets": preload("res://scenes/bullet_mechanics/level_movement_intro.tscn"),
	"raining_attack": preload("res://scenes/bullet_mechanics/raining_attack.tscn"),
	"merging_bullets": preload("res://scenes/bullet_mechanics/merging_bullets.tscn"),
	"blinking_rings": preload("res://scenes/bullet_mechanics/blinking_rings.tscn"),
	"hitbox_shift": preload("res://scenes/bullet_mechanics/collision_offset.tscn"),
	"final_round": preload("res://scenes/bullet_mechanics/rhythm_game.tscn")
}

var player_mechanics = {
	"grid_snap": preload("res://scenes/player_mechanics/grid_snap.tscn"),
	"force_push": preload("res://scenes/player_mechanics/force_push.tscn"),
	"gravity_switch": preload("res://scenes/player_mechanics/gravity_switch.tscn"),
	"hitbox_pulse": preload("res://scenes/player_mechanics/hitbox_pulse.tscn"),
	"hitbox_delay": preload("res://scenes/player_mechanics/hitbox_delay.tscn"),
	"shrinking_arena": preload("res://scenes/player_mechanics/shrinking_arena.tscn"),
	"tempo_warp": preload("res://scenes/player_mechanics/tempo_warp.tscn"),
	"time_delay": preload("res://scenes/player_mechanics/time_delay.tscn"),
	"final_round": preload("res://scenes/player_mechanics/rhythm_game.tscn"),
}

var test_bpm = 200.0
var test_channel = 0

func _ready() -> void:
	start_level(GameState.current_level)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		if !GameState.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			GameState.fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			GameState.fullscreen = false
	
	#if Input.is_key_pressed(KEY_T):
		#if Input.is_key_pressed(KEY_1):
			#test_bullet_mechanic("teleporting_attack", test_bpm)
		#elif Input.is_key_pressed(KEY_2):
			#test_bullet_mechanic("movement_sequence", test_bpm)
		#elif Input.is_key_pressed(KEY_3):
			#test_bullet_mechanic("black_hole", test_bpm)
		#elif Input.is_key_pressed(KEY_4):
			#test_player_mechanic("grid_snap", test_bpm)
		#elif Input.is_key_pressed(KEY_5):
			#test_player_mechanic("force_push", test_bpm)
		#elif Input.is_key_pressed(KEY_6):
			#test_player_mechanic("gravity_switch", test_bpm)
		#elif Input.is_key_pressed(KEY_7):
			#test_bullet_mechanic("falling_bullets", test_bpm)
		#elif Input.is_key_pressed(KEY_8):
			#test_bullet_mechanic("raining_attack", test_bpm)
		#elif Input.is_key_pressed(KEY_0):
			#start_level(1)
	#elif Input.is_key_pressed(KEY_Y):
		#if Input.is_key_pressed(KEY_1):
			#test_bullet_mechanic("merging_bullets", test_bpm)
		#if Input.is_key_pressed(KEY_2):
			#test_bullet_mechanic("blinking_rings", test_bpm)
		#if Input.is_key_pressed(KEY_3):
			#test_bullet_mechanic("hitbox_shift", test_bpm)
		#if Input.is_key_pressed(KEY_4):
			#test_player_mechanic("hitbox_pulse", test_bpm)
		#if Input.is_key_pressed(KEY_5):
			#test_player_mechanic("hitbox_delay", test_bpm)
		#if Input.is_key_pressed(KEY_6):
			#test_player_mechanic("shrinking_arena", test_bpm)
		#if Input.is_key_pressed(KEY_0):
			#start_level(2)
	#elif Input.is_key_pressed(KEY_U):
		#if Input.is_key_pressed(KEY_1):
			#test_player_mechanic("tempo_warp", test_bpm)
		#if Input.is_key_pressed(KEY_2):
			#test_player_mechanic("time_delay", test_bpm)
		#if Input.is_key_pressed(KEY_3):
			#test_bullet_mechanic("final_round", test_bpm)
		#if Input.is_key_pressed(KEY_4):
			#test_player_mechanic("final_round", test_bpm)
		#if Input.is_key_pressed(KEY_0):
			#start_level(3)

func switch_bullet_mechanic(id: String, disable: bool):
	if disable:
		if current_bullet_mechanic:
			current_bullet_mechanic.stop()
		return
	
	var new_attack
	if id:
		new_attack = bullet_mechanics[id].instantiate()
	
	if current_bullet_mechanic:
		current_bullet_mechanic.stop()
		current_bullet_mechanic.queue_free()
		for bullet in get_tree().current_scene.get_children():
			if bullet.is_in_group("bullet"):
				bullet.queue_free()
	
	if new_attack:
		current_bullet_mechanic = new_attack
		add_child(current_bullet_mechanic)
		current_bullet_mechanic.start(rhythm_controller_scene)

func switch_player_mechanic(id: String, disable: bool):
	if disable:
		if current_player_mechanic:
			current_player_mechanic.stop()
		return
	
	var new_attack
	if id:
		new_attack = player_mechanics[id].instantiate()
	
	if current_player_mechanic:
		current_player_mechanic.stop()
		current_player_mechanic.queue_free()
	
	if new_attack:
		current_player_mechanic = new_attack
		add_child(current_player_mechanic)
		current_player_mechanic.start(rhythm_controller_scene)

func start_level(level: int):
	var current_level: LevelData
	match level:
		1:
			current_level = level_movement
		2:
			current_level = level_collision
		3:
			current_level = level_time
	rhythm_controller_scene.bpm = current_level.bpm
	start.emit(current_level.song, current_level.events)

func test_bullet_mechanic(id: String, bpm: float):
	rhythm_controller_scene.bpm = bpm
	switch_bullet_mechanic(id, false)

func test_player_mechanic(id: String, bpm: float):
	rhythm_controller_scene.bpm = bpm
	switch_player_mechanic(id, false)
