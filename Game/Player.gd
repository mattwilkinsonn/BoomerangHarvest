extends CharacterBody2D

@export var MOVEMENT_SPEED = 300.0
@export var MAX_HEALTH = 100.0

const BoomerangScene = preload("res://Game/Boomerang.tscn")
const Plant = preload("res://Game/Plant.gd")
const Harvestable = preload("res://Game/Harvestable.gd")

var boomerang

signal harvested_changed
var harvested: int = 0:
	get:
		return harvested
	set(new_harvested):
		harvested_changed.emit(new_harvested)
		harvested = new_harvested

func _draw():
	var collision_shape = $CollisionShape2D.shape.size
	draw_rect(Rect2(-1 * collision_shape / 2, collision_shape), Color.BLUE)

func _ready():
	boomerang = BoomerangScene.instantiate()
	get_parent().add_child.call_deferred(boomerang)
	
	
func _physics_process(_delta):
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	set_movement(input_direction)

	move_and_slide()

func set_movement(input_direction: Vector2):
	velocity = input_direction * MOVEMENT_SPEED


func _input(event):
	if event.is_action_pressed("Throw"):
		throw_or_return()
	

func throw_or_return():
	if boomerang.state == Boomerang.BoomerangState.ON_PLAYER:
		boomerang.throw()
	elif boomerang.state == Boomerang.BoomerangState.FLYING:
		boomerang.start_returning()

func _on_gameplay_collider_body_entered(body):
	if body is Plant:
		collide_with_plant(body)
		
func collide_with_plant(plant: Plant):
	match plant.state:
		Plant.PlantState.SAPLING:
			pass
		Plant.PlantState.HARVESTABLE:
			pass
		Plant.PlantState.ZOMBIE:
			pass
	
	plant.queue_free()


func _on_gameplay_collider_area_entered(area: Area2D):
	if area is Harvestable:
		harvested += 1
		area.queue_free()
