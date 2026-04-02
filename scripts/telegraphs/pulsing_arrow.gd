extends Sprite2D

@export var active := false

var pulsing = false

const SPEED = 1

func _process(delta: float) -> void:
	if active:
		visible = true
	elif not active:
		visible = false
	
	if pulsing:
		modulate.a -= 0.02
		if modulate.a == 0:
			pulsing = false

func pulse():
	if not active:
		return
	modulate.a = 0.3
	pulsing = true
