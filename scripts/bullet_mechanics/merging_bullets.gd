extends BulletMechanic

@onready var shooter := $BulletShooter
@onready var area := $Area2D
@onready var player := $"../../Player"
var bullet_scene := preload("res://scenes/bullets/merging_bullet.tscn")

var shooter_1_pos: Vector2
var shooter_2_pos: Vector2
var shooter_1_dir_up := true
var shooter_2_dir_up := true
var step_unit := 40.0

func _ready() -> void:
	shooter.bullet_scene = bullet_scene
	shooter.visible = false
	shooter_1_pos = Vector2(get_viewport_rect().position.x - get_viewport_rect().size.x/4, randf_range(get_viewport_rect().position.y - get_viewport_rect().size.y/4, get_viewport_rect().position.y + get_viewport_rect().size.y/4))
	shooter_2_pos = Vector2(get_viewport_rect().position.x + get_viewport_rect().size.x/4, randf_range(get_viewport_rect().position.y - get_viewport_rect().size.y/4, get_viewport_rect().position.y + get_viewport_rect().size.y/4))
	$MeshInstance2D1.position = shooter_1_pos
	$MeshInstance2D2.position = shooter_2_pos

func _on_beat(beat_index):
	if not active:
		return
	
	if shooter_1_dir_up:
		shooter_1_pos.y -= step_unit
		$MeshInstance2D1.position = shooter_1_pos
		if shooter_1_pos.y - step_unit <= get_viewport_rect().position.y - get_viewport_rect().size.y/4:
			shooter_1_dir_up = false
	else:
		shooter_1_pos.y += step_unit
		$MeshInstance2D1.position = shooter_1_pos
		if shooter_1_pos.y + step_unit >= get_viewport_rect().position.y + get_viewport_rect().size.y/4:
			shooter_1_dir_up = true
	if shooter_2_dir_up:
		shooter_2_pos.y -= step_unit
		$MeshInstance2D2.position = shooter_2_pos
		if shooter_2_pos.y - step_unit <= get_viewport_rect().position.y - get_viewport_rect().size.y/4:
			shooter_2_dir_up = false
	else:
		shooter_2_pos.y += step_unit
		$MeshInstance2D2.position = shooter_2_pos
		if shooter_2_pos.y + step_unit >= get_viewport_rect().position.y + get_viewport_rect().size.y/4:
			shooter_2_dir_up = true
	
	if beat_index % 2 == 0:
		spawn_bullet(shooter_1_pos)
	else:
		spawn_bullet(shooter_2_pos)
	
func spawn_bullet(position):
	shooter.position = position
	#for i in range(8):
	if player:
		shooter.spawn_bullet((player.position - position).normalized(), 120.0)
