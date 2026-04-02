extends CharacterBody2D
class_name Player

signal death

const SPEED = 200.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 600.0

@export var has_mechanic = false
@export var current_mechanic : NodePath

var immortal := false
var lives := 5
var died := false
@onready var lives_ui := $"../CanvasLayer/LivesUI"
@onready var sprite := $AnimatedSprite2D
@onready var rhythm_controller := $"../RhythmController"
@onready var attack_manager := $"../AttackManager"

func _process(delta: float) -> void:
	if died:
		return
	if Input.is_action_just_pressed("p"):
		if not immortal:
			$CollisionShape2D.set_deferred("disabled", true)
			immortal = true
		else:
			$CollisionShape2D.set_deferred("disabled", true)
			immortal = false
	if lives <= 0 and not died:
		sprite.play("death")
		death.emit()
		died = true
	if lives_ui:
		lives_ui.position.x = (lives-5) * 48

func _physics_process(delta: float) -> void:
	if died:
		return
	if has_mechanic:
		var mechanic = get_node(current_mechanic)
		mechanic.physics_update(delta)
	else:
		var direction := Input.get_vector("left", "right", "up", "down")
		velocity = direction * SPEED
		
		move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "death":
		queue_free()

func _on_death() -> void:
	rhythm_controller.audio_stream_player.stop()
	get_tree().reload_current_scene()
