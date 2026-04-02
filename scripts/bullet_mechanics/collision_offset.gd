extends BulletMechanic

@onready var bullet_spawner := preload("res://scenes/bullets/bullet_spawner.tscn")
@onready var collision_preview := preload("res://scenes/telegraphs/collision_preview.tscn")

@export var min_distance_to_player := 10.0
@export var pos := Vector2(200, 100)
@export var spawn_count := 70
@export var min_distance_to_others := 20.0

@onready var player : CharacterBody2D = $"../../Player"

var moved := false
var move_speed := 0.5
var scale_dir := 1
var spawn_positions: Array[Vector2] = []

var beat_count := 0

var offset := 6.0
var hitbox_rotation := 0.0

func _ready() -> void:
	hitbox_rotation = randf_range(0, TAU)

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
	elif beat_count == 3:
		for spawner in get_children():
			if spawner.is_in_group("bullet_spawner"):
				spawner.active = true
				spawner.spawn_bullet()
				spawner.active = false
				spawner.queue_free()
		
		if get_tree():
			for bullet in get_tree().current_scene.get_children():
				if bullet.is_in_group("bullet"):
					bullet.get_node("Sprite2D").position += Vector2.UP.rotated(hitbox_rotation) * offset
					var col = collision_preview.instantiate()
					bullet.add_child(col)
					col.global_position = bullet.global_position
					col.visible = true
	elif beat_count == 4:
		moved = false
	else:
		for bullet in get_tree().current_scene.get_children():
			if bullet.is_in_group("bullet"):
				if not bullet.get_node("CollisionPreview"):
					break
				var col = bullet.get_node("CollisionPreview")
				if beat_index/2 % 2 == 0:
					col.visible = true
				else:
					col.visible = false

	beat_count += 1

func _physics_process(delta: float) -> void:
	if moved:
		return
	if get_tree():
		for bullet in get_tree().current_scene.get_children():
			if bullet.is_in_group("bullet"):
				bullet.scale += Vector2(0.01, 0.01) * scale_dir
				if bullet.scale <= Vector2(1, 1):
					scale_dir = 1
				elif bullet.scale >= Vector2(2, 2):
					scale_dir = -1
				bullet.move(Vector2.UP.rotated(randf_range(0, TAU)), move_speed, true)

func is_position_valid(pos: Vector2) -> bool:
	if pos.distance_to(player.global_position) <= min_distance_to_player:
		return false
	for other_pos in spawn_positions:
		if pos.distance_to(other_pos) < min_distance_to_others:
			return false
	spawn_positions.append(pos)
	return true
