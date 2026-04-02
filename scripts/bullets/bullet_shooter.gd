extends Node2D

@export var bullet_scene : PackedScene
@export var active := true

var id := 1
var is_merged := false

func spawn_bullet(direction : Vector2, speed: float):
	if not active:
		return
	
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.direction = direction
	bullet.speed = speed
	if "id" in bullet:
		bullet.id = id
		id += 1
	if is_merged:
		bullet.scale = Vector2(3, 3)
		
	if get_tree():
		if get_tree().current_scene:
			get_tree().current_scene.add_child(bullet)
	
func start():
	active = true
	
func stop():
	active = false

func spawn(pos : Vector2, rot : float):
	position = pos
	rotation = rot
