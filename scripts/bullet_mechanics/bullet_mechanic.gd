extends Node2D
class_name BulletMechanic

@export var active := false

var rhythm : RhythmController = null

func start(rhythm_controller):
	if active:
		return
	active = true
	rhythm = rhythm_controller
	if not rhythm.beat.is_connected(_on_beat):
		rhythm.beat.connect(_on_beat)
	
func stop():
	if not active:
		return
	active = false
	if rhythm and rhythm.beat.is_connected(_on_beat):
		rhythm.beat.disconnect(_on_beat)
	rhythm = null

func _on_beat(beat_index):
	pass
