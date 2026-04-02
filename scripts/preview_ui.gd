extends CanvasLayer

@onready var rhythm_controller = $".."
@onready var bullet_mechanic_preview = $BulletMechanicPreview
@onready var player_mechanic_preview = $PlayerMechanicPreview
@onready var bullet_mechanic_notif = $BulletMechanicNotif
@onready var player_mechanic_notif = $PlayerMechanicNotif

var current_bullet_mechanic: String
var current_player_mechanic: String
var next_bullet_mechanic: String
var next_player_mechanic: String

var bullet_mechanic_notif_pulsing := false
var player_mechanic_notif_pulsing := false

func _process(delta: float) -> void:
	if bullet_mechanic_notif_pulsing:
		bullet_mechanic_notif.modulate.a -= 0.002
		if bullet_mechanic_notif.modulate.a <= 0:
			bullet_mechanic_notif_pulsing = false
	if player_mechanic_notif_pulsing:
		player_mechanic_notif.modulate.a -= 0.002
		if player_mechanic_notif.modulate.a <= 0:
			player_mechanic_notif_pulsing = false

func _on_rhythm_controller_update_ui(type: LevelEvent.AttackType, current_mechanic: String, next_mechanic: String) -> void:
	if type == LevelEvent.AttackType.BULLET_MECHANIC:
		current_bullet_mechanic = current_mechanic
		notify_mechanic(type, current_bullet_mechanic)
		next_bullet_mechanic = next_mechanic
	elif type == LevelEvent.AttackType.PLAYER_MECHANIC:
		current_player_mechanic = current_mechanic
		notify_mechanic(type, current_player_mechanic)
		next_player_mechanic = next_mechanic
	
	bullet_mechanic_preview.text = "Next pattern: " + convert_mechanic_text(next_bullet_mechanic)
	player_mechanic_preview.text = "Next mechanic: " + convert_mechanic_text(next_player_mechanic)

func convert_mechanic_text(text: String) -> String:
	var words = text.replace("_", " ").split(" ")
	for i in words.size():
		words[i] = words[i].capitalize()
	return " ".join(words)

func notify_mechanic(type: LevelEvent.AttackType, mechanic: String):
	if type == LevelEvent.AttackType.BULLET_MECHANIC:
		bullet_mechanic_notif.text = convert_mechanic_text(mechanic)
		bullet_mechanic_notif.modulate.a = 0.3
		bullet_mechanic_notif_pulsing = true
	elif type == LevelEvent.AttackType.PLAYER_MECHANIC:
		player_mechanic_notif.text = convert_mechanic_text(mechanic)
		player_mechanic_notif.modulate.a = 0.3
		player_mechanic_notif_pulsing = true
