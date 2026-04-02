extends PlayerMechanic

@onready var ghost_path = preload("res://scenes/telegraphs/ghost_path.tscn")

var collision: CollisionShape2D
var collision2: CollisionShape2D
var sprite2: AnimatedSprite2D

var delay := 0.3

var position_history: Array[Vector2] = []

func _ready() -> void:
	collision = player.get_node("CollisionShape2D")
	collision2 = player.get_node("CollisionShape2D2")
	sprite2 = player.get_node("AnimatedSprite2D")
	
	collision2.visible = true

func physics_update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	player.velocity = direction * player.SPEED
		
	player.move_and_slide()
	
	position_history.append(player.global_position)
	var path = ghost_path.instantiate()
	if get_tree():
		get_tree().current_scene.add_child(path)
	path.position = player.global_position
	if position_history.size() > 60 * delay:
		var delayed_position = position_history.pop_front()
		collision.global_position = delayed_position
		sprite2.global_position = delayed_position

func stop():
	super()
	collision.global_position = collision2.global_position
	sprite2.global_position = collision2.global_position
	collision2.visible = false
