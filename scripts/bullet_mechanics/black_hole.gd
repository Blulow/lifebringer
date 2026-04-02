extends BulletMechanic

var bullet_scene := preload("res://scenes/bullets/bullet.tscn")

@export var gravity_radius: float = 300.0
@export var absorb_radius: float = 20.0
@export var gravity_strength: float = 900.0
@export var spiral_strength: float = 600.0

@export var spawn_radius := 500.0
@export var bullets_per_beat := 6
@export var feeder_speed := 120.0
@export var beats_before_pull := 16

var beat_count := 0
var spawn_angle := 0.0
var pulling := false

@onready var shooter := $BulletShooter

@export var beats_before_explode := 32
@export var explosion_bullets: int = 30
@export var explosion_speed: float = 400.0

var absorbed := 0

@onready var area: Area2D = $Area2D

var compressing := false

func _ready() -> void:
	position = Vector2(0, randf_range(get_viewport_rect().position.y - get_viewport_rect().size.y/4, get_viewport_rect().position.y + get_viewport_rect().size.y/4))
	shooter.visible = false

func _on_beat(beat_index):
	if not active:
		return
	
	beat_count += 1
	
	if not pulling:
		spawn_feeder_ring()

	if beat_count >= beats_before_pull:
		pulling = true
	
	if beat_count >= beats_before_explode:
		explode()
	
	if beat_count == beats_before_pull - 2:
		spiral_strength *= 1.5

	if beat_count == beats_before_explode - 1:
		gravity_strength *= 2.0
		spiral_strength *= 1.5
		compressing = true

func _physics_process(delta):
	if not active:
		return

	for body in area.get_overlapping_bodies():
		if not body.is_in_group("bullets"):
			continue

		apply_black_hole_force(body, delta)
	
	if compressing:
		scale *= 0.9
		if not active:
			compressing = false

func spawn_feeder_ring():
	for i in bullets_per_beat:
		var angle = spawn_angle + (TAU * i / bullets_per_beat)

		var spawn_pos = global_position + Vector2.RIGHT.rotated(angle) * spawn_radius
		var dir_to_center = (global_position - spawn_pos).normalized()

		shooter.spawn(spawn_pos, angle)
		shooter.spawn_bullet(dir_to_center, feeder_speed)

		# slow initial movement
		#var bullet = get_tree().current_scene.get_child(
			#get_tree().current_scene.get_child_count() - 1
		#)

	spawn_angle += TAU / 16

func apply_black_hole_force(bullet, delta):
	if not bullet.has_variable("direction"):
		return

	var to_center = global_position - bullet.global_position
	var distance = to_center.length()

	if distance > gravity_radius:
		return

	var dir_norm = to_center / distance

	# Gravity pull
	var gravity_factor = gravity_strength / max(distance, 10.0)

	# Perpendicular spiral force
	var spiral_dir = Vector2(-dir_norm.y, dir_norm.x)
	
	var new_dir = bullet.direction + (dir_norm * gravity_factor * delta) + (spiral_dir * spiral_strength * delta)

	bullet.velocity += new_dir.normalized()
	
	if distance < gravity_radius * 0.5:
		bullet.speed = lerp(bullet.speed, feeder_speed * 0.5, 0.05)

func explode():
	active = false

	for i in explosion_bullets:
		var angle = TAU * i / explosion_bullets
		spawn_explosion_bullet(angle)

	queue_free()


func spawn_explosion_bullet(angle):
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)

	bullet.global_position = global_position
	bullet.direction = Vector2.RIGHT.rotated(angle)
	bullet.speed = explosion_speed
