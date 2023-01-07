extends Node2D


const PlantScene = preload("res://Game/Plant.tscn")

var rand_generate = RandomNumberGenerator.new()
@export var PLANTS_TO_SPAWN = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_generate.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_plant_spawn_timer_timeout():
	for i in range(0, PLANTS_TO_SPAWN):
		var plant = PlantScene.instantiate()
		var x = rand_generate.randi_range(10, 1270)
		var y = rand_generate.randi_range(10, 710)
		plant.global_position = Vector2(x, y)
		add_child(plant)
