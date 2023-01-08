extends Node2D

const PlantScene = preload("res://Game/Plant/Plant.tscn")

@export var PLANTS_TO_SPAWN = 2.0
@export var PLANT_SPAWN_TIMER = 2.0
@export var GAME_TIME: int = 120

signal game_over(score)

var rand_generate = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_generate.randomize()
	$PlantSpawnTimer.start(PLANT_SPAWN_TIMER)
	$GameTimer.start(GAME_TIME)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var time_left = int($GameTimer.time_left)
	$GameHUD.set_time_remaining(time_left)


func _on_plant_spawn_timer_timeout():
	for i in range(0, PLANTS_TO_SPAWN):
		var plant = PlantScene.instantiate()
		var plant_type = rand_generate.randi_range(0, 2) as Plant.PlantType
		plant.init(plant_type)
		var spawn_number = rand_generate.randi_range(1, 75)
		var spawn_point = get_node("Spawns/SpawnPoint" + str(spawn_number))
		plant.global_position = spawn_point.global_position
		add_child(plant)


func _on_player_harvested_changed(harvested: int):
	$GameHUD.set_harvest_indicator(harvested)


func _on_game_hud_init_hud():
	pass


func _on_game_timer_timeout():
	emit_signal("game_over", $Player.harvested)
