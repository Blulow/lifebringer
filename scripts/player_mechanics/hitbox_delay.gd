extends PlayerMechanic

var collision: CollisionShape2D
var collision2: CollisionShape2D

var delay := 0.2

var position_history: Array[Vector2] = []

func _ready() -> void:
	player.scale = Vector2.ONE
	collision = player.get_node("CollisionShape2D")
	collision2 = player.get_node("CollisionShape2D2")
	collision.get_node("CollisionViewer").visible = true

func physics_update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.SPEED
		
	player.move_and_slide()
	
	position_history.append(player.global_position)
	if position_history.size() > 60 * delay:
		var delayed_position = position_history.pop_front()
		collision.global_position = delayed_position

func stop():
	super()
	if player:
		collision.global_position = player.global_position
		collision2.visible = false
