extends PlayerMechanic

var scale_dir := 1
var scale_speed := 0.05

var collision: Node2D

func _ready() -> void:
	collision = player.get_node("CollisionShape2D")
	collision.global_position = player.global_position

func physics_update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.SPEED
		
	player.move_and_slide()
	
	player.scale += Vector2.ONE * scale_speed * scale_dir
	if player.scale <= Vector2.ONE:
		scale_dir = 0
	if player.scale >= Vector2.ONE * 3:
		scale_dir = 0

func _on_beat(beat_index):
	if beat_index/2 % 2 == 0:
		scale_dir = 1
	else:
		scale_dir = -1

func stop():
	super()
	if player:
		player.scale = Vector2(1, 1)
