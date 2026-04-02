extends PlayerMechanic

@onready var move_force_arrow := $TelegraphingLayer/MoveForceArrow
@onready var pulsing_arrow := $TelegraphingLayer/PulsingArrow
@onready var rhythm_controller2 := $"../../RhythmController"

var switch_time := 2.0
var switch_timer := 0.0

var gravity_angle : float

var up_button : String
var left_button : String
var right_button : String

var new_gravity_angle := 0.0
var changed_gravity_angle := false
var pulse_start_time := 0.9
var pulse_interval := 0.3
var pulse_accumulator := 0.0

func _ready() -> void:
	switch_time = rhythm_controller2.bpm / 60

func physics_update(delta: float) -> void:
	switch_timer -= delta
	
	if switch_timer <= 0:
		gravity_angle = new_gravity_angle
		
		player.up_direction = Vector2.UP.rotated(gravity_angle)
		
		if gravity_angle > 7*PI/4 and gravity_angle <= 2*PI or gravity_angle >= 0 and gravity_angle <= PI/4:
			up_button = "up"
			left_button = "left"
			right_button = "right"
		elif gravity_angle > PI/4 and gravity_angle <= 3*PI/4:
			up_button = "right"
			left_button = "up"
			right_button = "down"
		elif gravity_angle > 3*PI/4 and gravity_angle <= 5*PI/4:
			up_button = "down"
			left_button = "right"
			right_button = "left"
		elif gravity_angle > 5*PI/4 and gravity_angle <= 7*PI/4:
			up_button = "left"
			left_button = "down"
			right_button = "up"
		switch_timer = switch_time

		move_force_arrow.rotation = gravity_angle + PI
		changed_gravity_angle = false
		move_force_arrow.active = true

	elif switch_timer <= pulse_start_time:
		if not changed_gravity_angle:
			new_gravity_angle = randf_range(0, 2*PI)
			pulsing_arrow.rotation = new_gravity_angle + PI
			changed_gravity_angle = true
			pulsing_arrow.active = true
			
	if switch_timer <= pulse_start_time and switch_timer > 0.0:
		pulse_accumulator += delta
		while pulse_accumulator >= pulse_interval:
			pulsing_arrow.pulse()
			pulse_accumulator -= pulse_interval
	
	var vel = player.velocity.rotated(-gravity_angle)
	if not player.is_on_floor():
		vel += Vector2(0, GRAVITY) * delta
	
	if Input.is_action_just_pressed(up_button) and player.is_on_floor():
		vel.y = JUMP_VELOCITY
	if Input.is_action_just_released(up_button) and vel.y < -1:
		vel.y = 1.0 / 2.5

	var direction := Input.get_axis(left_button, right_button)
	if direction:
		vel.x = direction * SPEED
	else:
		vel.x = move_toward(vel.x, 0, SPEED)
	
	player.velocity = vel.rotated(gravity_angle)
	
	player.move_and_slide()

func stop():
	super()
	move_force_arrow.active = false
	pulsing_arrow.active = false
