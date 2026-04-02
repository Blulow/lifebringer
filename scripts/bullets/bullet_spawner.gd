extends Node2D

@export var bullet_scene : PackedScene
@export var active := false

func spawn_bullet():
	if not active:
		return
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	if get_tree():
		get_tree().current_scene.add_child(bullet)
	
func start():
	active = true
	
func stop():
	active = false

func spawn(pos : Vector2, rot : float):
	position = pos
	rotation = rot
