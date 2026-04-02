extends PlayerMechanic

@onready var arena = $Arena

var scale_dir := -1
var scale_speed := 0.005

var collision: Node2D

func _ready() -> void:
	player.scale = Vector2.ONE
	collision = player.get_node("CollisionShape2D")
	collision.global_position = player.global_position

func physics_update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * SPEED
	
	player.move_and_slide()
	
	arena.global_position = get_viewport_rect().position
	arena.scale += Vector2.ONE * scale_dir * scale_speed
	if arena.scale <= Vector2(0.3, 0.3):
		scale_dir = 1
	if arena.scale >= Vector2(1, 1):
		scale_dir = -1

func _on_beat(beat_index):
	if beat_index % 2 == 0:
		arena.modulate = Color(1, 0, 0, 1)
	else:
		arena.modulate = Color(1, 1, 1, 1)
