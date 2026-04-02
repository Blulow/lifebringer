extends Player
class_name PlayerMechanic

@onready var player : CharacterBody2D = $"../../Player"

@export var active := false

var rhythm : RhythmController = null

func start(rhythm_controller):
	if active:
		return
	if not player:
		return
	active = true
	player.has_mechanic = true
	player.current_mechanic = get_path()
	rhythm = rhythm_controller
	if not rhythm.beat.is_connected(_on_beat):
		rhythm.beat.connect(_on_beat)
	
func stop():
	if not active:
		return
	if not player:
		return
	active = false
	player.has_mechanic = false
	if rhythm and rhythm.beat.is_connected(_on_beat):
		rhythm.beat.disconnect(_on_beat)
	rhythm = null

func _on_beat(beat_index):
	pass

func physics_update(delta: float) -> void:
	pass
