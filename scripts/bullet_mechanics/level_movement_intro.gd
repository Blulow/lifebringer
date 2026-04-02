extends BulletMechanic

@onready var bullet_shooter := $BulletShooter

@export var min_distance := 70.0
@export var pos := Vector2(200, 200)
@export var angle := 0.0

@onready var player : CharacterBody2D = $"../../Player"

func _ready() -> void:
	bullet_shooter.visible = false
	bullet_shooter.spawn(pos, angle)

func _on_beat(beat_index):
	if not active:
		return
	
	for i in range(10):
		bullet_shooter.position = Vector2(get_viewport_rect().position.x + get_viewport_rect().size.x / 4, get_viewport_rect().position.y - get_viewport_rect().size.y / 4 + 10 * i)
		bullet_shooter.spawn_bullet(Vector2.LEFT, 500.0)
	for i in range(10):
		bullet_shooter.position = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x / 4, get_viewport_rect().position.y + get_viewport_rect().size.y / 4 - 10 * i)
		bullet_shooter.spawn_bullet(Vector2.RIGHT, 500.0)
	for i in range(10):
		if beat_index % 2 == 0:
			bullet_shooter.position = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x / 4 + 100 * i, get_viewport_rect().position.y - get_viewport_rect().size.y / 4)
			bullet_shooter.spawn_bullet(Vector2.DOWN, 200.0)
			bullet_shooter.position = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x / 4 + 100 * i - 15, get_viewport_rect().position.y - get_viewport_rect().size.y / 4)
			bullet_shooter.spawn_bullet(Vector2.DOWN, 200.0)
			bullet_shooter.position = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x / 4 + 100 * i + 15, get_viewport_rect().position.y - get_viewport_rect().size.y / 4)
			bullet_shooter.spawn_bullet(Vector2.DOWN, 200.0)
		else:
			bullet_shooter.position = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x / 4 + 100 * i + 35, get_viewport_rect().position.y - get_viewport_rect().size.y / 4)
			bullet_shooter.spawn_bullet(Vector2.DOWN, 200.0)
			bullet_shooter.position = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x / 4 + 100 * i + 50, get_viewport_rect().position.y - get_viewport_rect().size.y / 4)
			bullet_shooter.spawn_bullet(Vector2.DOWN, 200.0)
			bullet_shooter.position = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x / 4 + 100 * i + 65, get_viewport_rect().position.y - get_viewport_rect().size.y / 4)
			bullet_shooter.spawn_bullet(Vector2.DOWN, 200.0)
