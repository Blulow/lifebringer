extends PlayerMechanic

const step_time := 0.15
var move_timer := 0.15
var step_unit := 20.0

func physics_update(delta: float) -> void:
	move_timer -= delta
	if move_timer <= 0.0:
		if Input.is_action_pressed("left"):
			if not player.position.x - step_unit <= get_viewport_rect().position.x - get_viewport_rect().size.x/4 + step_unit/2:
				player.position.x -= step_unit
		if Input.is_action_pressed("right"):
			if not player.position.x + step_unit >= get_viewport_rect().position.x + get_viewport_rect().size.x/4 - step_unit/2:
				player.position.x += step_unit
		if Input.is_action_pressed("up"):
			if not player.position.y - step_unit <= get_viewport_rect().position.y - get_viewport_rect().size.y/4 + step_unit/2:
				player.position.y -= step_unit
		if Input.is_action_pressed("down"):
			if not player.position.y + step_unit >= get_viewport_rect().position.y + get_viewport_rect().size.y/4 - step_unit/2:
				player.position.y += step_unit
		move_timer = step_time
		
func stop():
	super()
	if player:
		player.get_node("CollisionShape2D").global_position = player.get_node("CollisionShape2D2").global_position
