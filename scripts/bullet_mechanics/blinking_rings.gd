extends BulletMechanic

@onready var ring_scene := preload("res://scenes/bullets/blinking_ring.tscn")
@onready var warning := $Warning
#@onready var shooter := $BulletShooter
#@onready var player := $"../../Player"

#func _ready() -> void:
	#shooter.spawn(get_viewport_rect().position, 0)

var pulsed := false
var timer := 0.9
var pulse_accumulator := 0.0
var pulse_interval := 0.3

func _ready() -> void:
	warning.active = true
	warning.position = Vector2(0, 0)

func _process(delta: float) -> void:
	if timer <= 0:
		return
	
	if timer > 0.0:
		pulse_accumulator += delta
		while pulse_accumulator >= pulse_interval:
			warning.pulse()
			pulse_accumulator -= pulse_interval
	timer -= delta	

func _on_beat(beat_index):
	if not active:
		return

	if beat_index % 4 == 0:
		var ring = ring_scene.instantiate()
		if get_tree():
			get_tree().current_scene.add_child(ring)
		ring.expanding = true

	#if player:
		#shooter.spawn_bullet((player.position - position).normalized().rotated(randf_range(-PI/4, PI/4)), 200)

func stop():
	super()
	warning.active = false
