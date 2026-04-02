extends Resource
class_name LevelEvent

@export var beat: int
@export var event_type: EventType
@export var attack_type: AttackType
@export var attack_pattern: String

enum EventType {
	START_ATTACK,
	DISABLE_ATTACK,
	STOP_ATTACK
}

enum AttackType{
	BULLET_MECHANIC,
	PLAYER_MECHANIC
}
