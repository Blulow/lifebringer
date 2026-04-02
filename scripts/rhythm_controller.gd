extends Node2D
class_name RhythmController

@onready var attack_manager = $"../AttackManager"
@onready var audio_stream_player := $AudioStreamPlayer

@export var bpm := 0.0
signal beat(beat_index : int)

var timer := 0.0
var beat_length := 0.0
var beat_count := 0

var click := false
var start := false

var level_events : Array[LevelEvent]
var current_event_index := 0

signal update_ui(type: LevelEvent.AttackType, current_mechanic: String, next_mechanic: String)
var current_bullet_mechanic: String
var current_player_mechanic: String
var next_bullet_mechanic: String
var next_player_mechanic: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_manager.start.connect(_on_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bpm == 0:
		return
	else:
		beat_length = 60.0 / bpm
	
	timer += delta
	while timer >= beat_length:
		timer -= beat_length
		beat_count += 1
		beat.emit(beat_count)

func _on_beat(beat_index) -> void:	
	if not start:
		return
	
	while current_event_index < level_events.size():
		var event = level_events[current_event_index]
		if not event:
			break
		
		if event.beat > beat_index:
			break
		
		match event.attack_type:
			LevelEvent.AttackType.BULLET_MECHANIC:
				current_bullet_mechanic = "None" if event.attack_pattern == "e" else event.attack_pattern
				match event.event_type:
					LevelEvent.EventType.START_ATTACK:
						attack_manager.switch_bullet_mechanic(event.attack_pattern, false)
					LevelEvent.EventType.DISABLE_ATTACK:
						attack_manager.switch_bullet_mechanic("", true)
					LevelEvent.EventType.STOP_ATTACK:
						attack_manager.switch_bullet_mechanic("", false)
			LevelEvent.AttackType.PLAYER_MECHANIC:
				current_player_mechanic = "None" if event.attack_pattern == "e" else event.attack_pattern
				match event.event_type:
					LevelEvent.EventType.START_ATTACK:
						attack_manager.switch_player_mechanic(event.attack_pattern, false)
					LevelEvent.EventType.DISABLE_ATTACK:
						attack_manager.switch_player_mechanic("", true)
					LevelEvent.EventType.STOP_ATTACK:
						attack_manager.switch_player_mechanic("", false)
		
		var i := 1
		if not current_event_index + i >= level_events.size() - 1:
			while level_events[current_event_index + i].attack_type != LevelEvent.AttackType.BULLET_MECHANIC:
				i += 1
			next_bullet_mechanic = "None" if level_events[current_event_index + i].attack_pattern == "e" else level_events[current_event_index + i].attack_pattern
		update_ui.emit(LevelEvent.AttackType.BULLET_MECHANIC, current_bullet_mechanic, next_bullet_mechanic)
		var j := 1
		if not current_event_index + j >= level_events.size() - 1:
			while level_events[current_event_index + j].attack_type != LevelEvent.AttackType.PLAYER_MECHANIC:
				j += 1
			next_player_mechanic = "None" if level_events[current_event_index + j].attack_pattern == "e" else level_events[current_event_index + j].attack_pattern
		update_ui.emit(LevelEvent.AttackType.PLAYER_MECHANIC, current_player_mechanic, next_player_mechanic)
		
		current_event_index += 1
	
	if beat_index == 1:
		audio_stream_player.play()

func _on_start(song: AudioStream, events: Array[LevelEvent]):
	start = true
	audio_stream_player.stream = song
	level_events = events

func _on_audio_stream_player_finished() -> void:
	if GameState.current_level + 1 <= 3:
		GameState.current_level += 1
		get_tree().change_scene_to_file("res://scenes/level_entry.tscn")
	elif GameState.current_level + 1 == 4:
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
