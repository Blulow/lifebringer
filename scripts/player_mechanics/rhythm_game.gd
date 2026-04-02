extends PlayerMechanic

const step_time := 0.15
const starting_point := Vector2(-220, -110)
var move_timer := 0.0
var step_unit := 28.0

var can_move := false

func _ready() -> void:
	player.global_position = starting_point

func physics_update(delta: float) -> void:
	if not can_move:
		return
	
	if Input.is_action_just_pressed("left"):
		if not player.global_position.x - step_unit <= get_viewport_rect().position.x - get_viewport_rect().size.x/4 + step_unit/2:
			player.global_position.x -= step_unit
	if Input.is_action_just_pressed("right"):
		if not player.global_position.x + step_unit >= get_viewport_rect().position.x + get_viewport_rect().size.x/4 - step_unit/2:
			player.global_position.x += step_unit
	if Input.is_action_just_pressed("up"):
		if not player.global_position.y - step_unit <= get_viewport_rect().position.y - get_viewport_rect().size.y/4 + step_unit/2:
			player.global_position.y -= step_unit
	if Input.is_action_just_pressed("down"):
		if not player.global_position.y + step_unit >= get_viewport_rect().position.y + get_viewport_rect().size.y/4 - step_unit/2:
			player.global_position.y += step_unit
	
	if not check_in_path():
		player.lives -= 5

func check_in_path() -> bool:
	if get_tree():
		for i in get_tree().current_scene.get_children():
			if i.is_in_group("rhythm_path"):
				if player.global_position == i.global_position:
					return true
	return false

func _on_beat(beat_index):
	if not can_move:
		can_move = true

func stop():
	super()
	if get_tree():
		var path_i: int
		for j in get_tree().current_scene.get_children():
			if j.is_in_group("rhythm_path"):
				if not path_i:
					path_i = j.get_index()
				if j.get_index() <= 52 + path_i:
					if player.global_position == j.global_position:
						player.lives -= 5
