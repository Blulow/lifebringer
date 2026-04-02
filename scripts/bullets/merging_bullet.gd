extends Area2D

@onready var shooter := $BulletShooter
@onready var player := $"../Player"
var bullet_scene := preload("res://scenes/bullets/merging_bullet.tscn")

@export var speed := 100.0
var direction := Vector2.ZERO

const move_speed = 2
var id := 1

func _ready() -> void:
	shooter.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body:
		if body.shape_owner_get_owner(body.shape_find_owner(body_shape_index)).is_in_group("collision_shape_2"):
			return
		if "lives" in body:
			body.lives -= 1

func move(dir : Vector2):
	position += dir * move_speed
	
	if position.x < get_viewport_rect().position.x - get_viewport_rect().size.x/4:
		position.x = get_viewport_rect().position.x + get_viewport_rect().size.x/4
	elif position.x > get_viewport_rect().position.x + get_viewport_rect().size.x/4:
		position.x = get_viewport_rect().position.x - get_viewport_rect().size.x/4
	if position.y < get_viewport_rect().position.y - get_viewport_rect().size.y/4:
		position.y = get_viewport_rect().position.y + get_viewport_rect().size.y/4
	elif position.y > get_viewport_rect().position.y + get_viewport_rect().size.y/4:
		position.y = get_viewport_rect().position.y - get_viewport_rect().size.y/4

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		if not area.id:
			return
		if id > area.id:
			return
		
		shooter.position = position
		shooter.is_merged = true
		if player:
			shooter.spawn_bullet((player.position - position).normalized(), 150.0)
		
		area.queue_free()
		queue_free()
