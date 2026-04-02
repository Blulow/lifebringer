extends BulletMechanic

@onready var player : CharacterBody2D = $"../../Player"
@onready var rhythm_path := preload("res://scenes/bullets/rhythm_path.tscn")

var spawned := false

const starting_point := Vector2(-220, -110)
var total_direction := Vector2.ZERO
var rot := 0.0
var step_unit := 28
	
func _on_beat(beat_index):
	if not active:
		return
	
	if not spawned:
		for i in range(89):
			if i == 0:
				rot = PI/2
			elif i >= 1 and i <= 7:
				total_direction += Vector2.DOWN
			elif i == 8:
				total_direction += Vector2.DOWN
				rot = 0
			elif i >= 9 and i <= 23:
				total_direction += Vector2.RIGHT
			elif i == 24:
				total_direction += Vector2.RIGHT
				rot = -PI/2
			elif i >= 25 and i <= 31:
				total_direction += Vector2.UP
			elif i == 32:
				total_direction += Vector2.UP
				rot = -PI
			elif i >= 33 and i <= 45:
				total_direction += Vector2.LEFT
			elif i == 46:
				total_direction += Vector2.LEFT
				rot = PI/2
			elif i >= 47 and i <= 51:
				total_direction += Vector2.DOWN
			elif i == 52:
				total_direction += Vector2.DOWN
				rot = 0
			elif i >= 53 and i <= 63:
				total_direction += Vector2.RIGHT
			elif i == 64:
				total_direction += Vector2.RIGHT
				rot = -PI/2
			elif i >= 65 and i <= 67:
				total_direction += Vector2.UP
			elif i == 68:
				total_direction += Vector2.UP
				rot = -PI
			elif i >= 69 and i <= 77:
				total_direction += Vector2.LEFT
			elif i == 78:
				total_direction += Vector2.LEFT
				rot = PI/2
			elif i == 79:
				total_direction += Vector2.DOWN
			elif i == 80:
				total_direction += Vector2.DOWN
				rot = 0
			elif i >= 81 and i <= 88:
				total_direction += Vector2.RIGHT
			spawn_path(starting_point + total_direction * step_unit, rot)
	
			if get_tree():
				var path_i: int
				for j in get_tree().current_scene.get_children():
					if j.is_in_group("rhythm_path"):
						if not path_i:
							path_i = j.get_index()
						if j.get_index() <= 52 + path_i:
							j.pulse()
	spawned = true

func spawn_path(pos: Vector2, rot: float):
	var path = rhythm_path.instantiate()
	if get_tree():
		get_tree().current_scene.add_child(path)
	path.global_position = pos
	path.rotation = rot
