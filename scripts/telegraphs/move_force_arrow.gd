extends Sprite2D

@export var active := false

var pulsing = false
var starting_pos : Vector2

const SPEED = 1

func _ready() -> void:
	starting_pos = position

func _process(delta: float) -> void:
	if active:
		visible = true
	elif not active:
		visible = false

func move_force(rotation2 : float):
	if not active:
		return
	
	rotation = rotation2 + PI/2
	position += Vector2.UP.rotated(rotation) * SPEED
	if position.distance_to(starting_pos) >= 64:
		position = starting_pos
