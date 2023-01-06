extends CharacterBody2D

@export var MOVEMENT_SPEED = 300.0

const BoomerangScene = preload("res://Boomerang.tscn")

var boomerang

func _ready():
	boomerang = BoomerangScene.instantiate()
	get_parent().add_child.call_deferred(boomerang)

func _physics_process(delta):
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
