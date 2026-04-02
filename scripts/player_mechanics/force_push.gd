extends PlayerMechanic

@onready var arrow := $TelegraphingLayer/MoveForceArrow

const step_time := 0.15
var move_timer := 0.0

var force_angle : float
var force_velocity := Vector2.ZERO
var force_strength : float

func _ready() -> void:
	force_angle = randf_range(0, 2 * PI)
	force_velocity = Vector2.RIGHT.rotated(force_angle)
	force_strength = 100

func physics_update(delta: float) -> void:
	if arrow:
		if not arrow.active:
			arrow.active = true
	
	var direction := Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * SPEED
	player.velocity += force_velocity * force_strength
	
	if arrow.active:
		arrow.move_force(force_angle)
	
	player.move_and_slide()

func stop():
	super()
	arrow.active = false
