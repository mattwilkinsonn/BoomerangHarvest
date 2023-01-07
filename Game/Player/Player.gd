extends CharacterBody2D

@export var MOVEMENT_SPEED = 300.0
@export var SLOWED_MOVEMENT_SPEED = 150.0
@export var MAX_HEALTH = 100.0

const BoomerangScene = preload("res://Game/Player/Boomerang.tscn")
const Plant = preload("res://Game/Plant/Plant.gd")
const Harvestable = preload("res://Game/Harvestable.gd")
const Poison = preload("res://Game/Plant/Enemy/Poison.gd")

var boomerang

enum MovementState {
	NORMAL,
	SLOWED
}

var movement_state: MovementState = MovementState.NORMAL

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
	
	movement_state = MovementState.NORMAL
	for area in $GameplayCollider.get_overlapping_areas():
		if area.get_parent() is Poison:
			movement_state = MovementState.SLOWED
			break


func set_movement(input_direction: Vector2):
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
