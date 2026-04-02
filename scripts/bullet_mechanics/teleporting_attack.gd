extends BulletMechanic

@onready var bullet_shooter := $BulletShooter

@export var min_distance := 70.0
@export var pos := Vector2(200, 200)
@export var angle := 0.0

@onready var player : CharacterBody2D = $"../../Player"

func _ready() -> void:
	bullet_shooter.spawn(pos, angle)

func _on_beat(beat_index):
	if not active:
		return

	if player:
		pos = Vector2(randf_range(get_viewport_rect().position.x - get_viewport_rect().size.x/4, get_viewport_rect().position.x + get_viewport_rect().size.x/4), randf_range(get_viewport_rect().position.y - get_viewport_rect().size.y/4, get_viewport_rect().position.y + get_viewport_rect().size.y/4))
		while (pos.distance_to(player.global_position) <= min_distance):
			pos = Vector2(randf_range(get_viewport_rect().position.x - get_viewport_rect().size.x/4, get_viewport_rect().position.x + get_viewport_rect().size.x/4), randf_range(get_viewport_rect().position.y - get_viewport_rect().size.y/4, get_viewport_rect().position.y + get_viewport_rect().size.y/4))
	bullet_shooter.position = pos
	
	if player:
		bullet_shooter.look_at(player.global_position)
		#var dir = (player.global_position - global_position).normalized()
		#angle = dir.angle()
		#print()
	angle = bullet_shooter.rotation
	#bullet_spawner.rotation = angle
	bullet_shooter.spawn_bullet(Vector2.RIGHT.rotated(angle), 100.0)
