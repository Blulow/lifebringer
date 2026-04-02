extends BulletMechanic

@onready var bullet_spawner := preload("res://scenes/bullets/bullet_spawner.tscn")

@export var min_distance_to_player := 40.0
@export var pos := Vector2(200, 100)
@export var spawn_count := 30
@export var min_distance_to_others := 50.0

@onready var player : CharacterBody2D = $"../../Player"
@onready var arrow := $TelegraphingLayer/PulsingArrow

var moving := false
var move_dir := Vector2.ZERO
var move_speed := 2.0
var spawn_positions: Array[Vector2] = []

var beat_count := 0

func _on_beat(beat_index):
	if not active:
		return
	
	if beat_count == 0:
		beat_count += 1
		return
	
	if beat_count == 1:
		for i in range(spawn_count):
			if player:
				pos = Vector2(randf_range(get_viewport_rect().position.x - get_viewport_rect().size.x/4, get_viewport_rect().position.x + get_viewport_rect().size.x/4), randf_range(get_viewport_rect().position.y - get_viewport_rect().size.y/4, get_viewport_rect().position.y + get_viewport_rect().size.y/4))
				while not is_position_valid(pos):
					pos = Vector2(randf_range(get_viewport_rect().position.x - get_viewport_rect().size.x/4, get_viewport_rect().position.x + get_viewport_rect().size.x/4), randf_range(get_viewport_rect().position.y - get_viewport_rect().size.y/4, get_viewport_rect().position.y + get_viewport_rect().size.y/4))
			
			var spawner = bullet_spawner.instantiate()
			add_child(spawner)
			spawner.spawn(pos, 0)
	elif beat_count == 2:
		for spawner in get_children():
			if spawner.is_in_group("bullet_spawner"):
				spawner.active = true
				spawner.spawn_bullet()
				spawner.active = false
				spawner.queue_free()
	else:
		if beat_count % 2 == 0:
			var angle = randf_range(0, 2*PI)
			
			moving = true
			move_dir = Vector2.UP.rotated(angle)

			arrow.active = true
			arrow.rotation = angle
			arrow.pulse()
	
	beat_count += 1

func _physics_process(delta: float) -> void:
	if not moving:
		return
	if get_tree():
		for bullet in get_tree().current_scene.get_children():
			if bullet.is_in_group("bullet"):
				bullet.move(move_dir, move_speed, false)

func is_position_valid(pos: Vector2) -> bool:
	if pos.distance_to(player.global_position) <= min_distance_to_player:
		return false
	for other_pos in spawn_positions:
		if pos.distance_to(other_pos) < min_distance_to_others:
			return false
	spawn_positions.append(pos)
	return true

func stop():
	super()
	if arrow:
		arrow.active = false
