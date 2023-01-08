extends CharacterBody2D

@export var MOVEMENT_SPEED = 150.0
@export var LIFE_TIME = 5.0
@export var DELAYED_DEATH_TIME = 0.001

const PlantDeathScene = preload("res://Game/Plant/PlantDeath.tscn")

var player

func _ready():
	player = get_node("../Player")
	$DeathTimer.start(LIFE_TIME)

func flip(x_direction: float):
	$AnimatedSprite2D.flip_h = x_direction < 0
	

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	flip(direction.x)
	velocity = direction * MOVEMENT_SPEED

	move_and_slide()

func delayed_death():
	$DeathTimer.start(DELAYED_DEATH_TIME)

func _on_death_timer_timeout():
	death()

func death():
	var plant_death = PlantDeathScene.instantiate()
	plant_death.global_position = global_position
	get_parent().add_child.call_deferred(plant_death)
	queue_free()


func _on_gameplay_collider_area_entered(area):
	if area.get_parent() == player:
		player.bump(global_position.direction_to(player.global_position), Player.BumpType.NUDGE)
