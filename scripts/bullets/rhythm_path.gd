extends Area2D

@onready var rhythm_controller := $"../RhythmController"
var pulsing := false
var pulse_dir := -1

func _ready() -> void:
	rhythm_controller.beat.connect(_on_beat)

func _process(delta: float) -> void:
	if not pulsing:
		return
	
	modulate.g += 0.1 * pulse_dir
	modulate.b += 0.1 * pulse_dir

func pulse():
	if not pulsing:
		modulate = Color(1, 0.5, 0.5, 1)
		pulsing = true

func _on_beat(beat_index):
	if not pulsing:
		return
	
	if modulate.g <= 0 and modulate.b <= 0:
		pulse_dir = 1
	elif modulate.g >= 1 and modulate.b >= 1:
		pulse_dir = -1
