extends Sprite2D

var timer := 0.3

func _process(delta: float) -> void:
	modulate.a = timer
	if timer <= 0.0:
		queue_free()
	timer -= delta
