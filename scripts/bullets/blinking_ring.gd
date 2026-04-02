extends Area2D

@onready var rhythm_controller := $"../RhythmController"

var in_outer := false
var in_inner := false

@export var speed := 100.0
var direction := Vector2.ZERO

var thickness := 0.2

var expanding := false
var radius := 1.6
var expand_speed := 0.12

var active := true
var inited := false

func _ready() -> void:
	rhythm_controller.beat.connect(_on_beat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not inited:
		return
	position += direction * speed * delta
	
	if expanding:
		scale += Vector2.ONE * expand_speed
		if scale >= Vector2.ONE * 270:
			expanding = false

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not active:
		return
	
	if body.shape_owner_get_owner(body.shape_find_owner(body_shape_index)).is_in_group("collision_shape_2"):
		return
	if not "lives" in body:
		return
	
	if $InnerArea.get_overlapping_areas().has(body):
		in_inner = true
	else:
		in_outer = true
	
	check_ring_state(body)

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body:
		if body.shape_owner_get_owner(body.shape_find_owner(body_shape_index)).is_in_group("collision_shape_2"):
			return
		if not "lives" in body:
			return

	in_outer = false
	in_inner = false
	
	check_ring_state(body)

func check_ring_state(body: Node2D):
	if not in_inner and in_outer:
		body.lives -= 1

func set_active(value: bool):
	active = value
	
	if active:
		modulate.a = 1
	else:
		modulate.a = 0.3
		in_inner = false
		in_outer = false

func _on_beat(beat_index):
	if not inited:
		inited = true
		return
	if beat_index / 2 % 2 == 0:
		set_active(false)
	else:
		set_active(true)
