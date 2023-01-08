extends CharacterBody2D
class_name Player

@export var MOVEMENT_SPEED = 300.0
@export var SLOWED_MOVEMENT_SPEED = 150.0
@export var MAX_HEALTH = 100.0
@export var NUDGE_BUMP_TIME = 0.2
@export var NUDGE_BUMP_DISTANCE = 100.0
@export var EXPLOSION_BUMP_TIME = 0.2
@export var EXPLOSION_BUMP_DISTANCE = 175.0
@export var BUMP_TIMEOUT = 0.15

const BoomerangScene = preload("res://Game/Player/Boomerang.tscn")
const Plant = preload("res://Game/Plant/Plant.gd")
const Harvestable = preload("res://Game/Harvestable.gd")
const Poison = preload("res://Game/Plant/Enemy/Poison.gd")

var boomerang

enum MovementState {
	NORMAL,
	SLOWED,
	BUMPING
}

var movement_state: MovementState = MovementState.NORMAL

enum BumpType {
	NUDGE,
	EXPLOSION
}

var bump_direction: Vector2
var bump_type: BumpType
var nudge_bump_magnitude: float = NUDGE_BUMP_DISTANCE / NUDGE_BUMP_TIME
var explosion_bump_magnitude: float = EXPLOSION_BUMP_DISTANCE / EXPLOSION_BUMP_TIME

signal harvested_changed
var harvested: int = 0:
	get:
		return harvested
	set(new_harvested):
		harvested_changed.emit(new_harvested)
		harvested = new_harvested


func _ready():
	boomerang = BoomerangScene.instantiate()
	get_parent().add_child.call_deferred(boomerang)


func _physics_process(_delta):
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	set_movement(input_direction)

	move_and_slide()


func _process(delta):
	if velocity.y < 0:
		$AnimatedSprite2D.play("up")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("down")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("right")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("left")
	
	if movement_state != MovementState.BUMPING:
		movement_state = MovementState.NORMAL
		for area in $GameplayCollider.get_overlapping_areas():
			if area.get_parent() is Poison:
				movement_state = MovementState.SLOWED
				break


func set_movement(input_direction: Vector2):
	if movement_state == MovementState.BUMPING:
		var bump_magnitude = nudge_bump_magnitude if bump_type == BumpType.NUDGE else explosion_bump_magnitude
		velocity = bump_direction * bump_magnitude
		return
	
	var movement_speed
	match movement_state:
		MovementState.NORMAL:
			movement_speed = MOVEMENT_SPEED
		MovementState.SLOWED:
			movement_speed = SLOWED_MOVEMENT_SPEED
	
	velocity = input_direction * movement_speed


func _input(event):
	if event.is_action_pressed("Throw"):
		throw_or_return()


func throw_or_return():
	if boomerang.state == Boomerang.BoomerangState.ON_PLAYER:
		boomerang.throw()
	elif boomerang.state == Boomerang.BoomerangState.FLYING:
		boomerang.state = Boomerang.BoomerangState.RETURNING


func _on_gameplay_collider_body_entered(body):
	if body is Plant:
		collide_with_plant(body)


func collide_with_plant(plant: Plant):
	match plant.state:
		Plant.PlantState.SAPLING:
			pass
		Plant.PlantState.HARVESTABLE:
			pass

	plant.queue_free()


func _on_gameplay_collider_area_entered(area: Area2D):
	if area is Harvestable:
		harvested += 1
		area.queue_free()

func bump(direction: Vector2, type: BumpType):
	if not $BumpTimer.is_stopped():
		return
	bump_direction = direction
	bump_type = type
	movement_state = MovementState.BUMPING
	$BumpTimer.start(NUDGE_BUMP_TIME if bump_type == BumpType.NUDGE else EXPLOSION_BUMP_TIME)

func _on_bump_timer_timeout():
	if movement_state == MovementState.BUMPING:
		movement_state = MovementState.NORMAL
		$BumpTimer.start(BUMP_TIMEOUT)
	
