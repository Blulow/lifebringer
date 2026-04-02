extends PlayerMechanic

@onready var rhythm_controller2 = $"../../RhythmController"

func _ready() -> void:
	rhythm_controller2.bpm = 100.0

func physics_update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.SPEED
	
	player.move_and_slide()

func stop():
	super()
	rhythm_controller2.bpm = 200.0
