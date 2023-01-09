extends Area2D

@export var EXPLOSION_TIME = 0.2
@export var EFFECT_TIME = 0.5
@export var COLOR = Color.ORANGE

const Zombie = preload("res://Game/Plant/Enemy/Zombie.gd")
const Plant = preload("res://Game/Plant/Plant.gd")
const Poison = preload("res://Game/Plant/Enemy/Poison.gd")
const Bomb = preload("res://Game/Plant/Enemy/Bomb.gd")

var player

enum ExplosionState {
	STARTED,
	PUSHED
}
var explosion_state: ExplosionState = ExplosionState.STARTED

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../Player")
	$LifeTimer.start(EXPLOSION_TIME)
	$ExplosionPlayer.play()
	$ExplosionVFX.emitting = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_life_timer_timeout():
	if explosion_state == ExplosionState.STARTED:
		for area in get_overlapping_areas():
			var parent = area.get_parent()
			if parent == player:
				player.bump(global_position.direction_to(player.global_position), Player.BumpType.EXPLOSION)
				continue
			if parent is Zombie:
				parent.queue_free()
		
		for body in get_overlapping_bodies():
			if body is Plant or body is Poison:
				body.queue_free()
			
			if body is Bomb:
				body.explode_delayed()
		explosion_state = ExplosionState.PUSHED
		$LifeTimer.start(EFFECT_TIME)
		return
	
	queue_free()
