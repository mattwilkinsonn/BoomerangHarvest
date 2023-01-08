extends Node2D

const PlantScene = preload("res://Game/Plant/Plant.tscn")

@export var PLANTS_TO_SPAWN = 2.0
@export var PLANT_SPAWN_TIMER = 2.0

var game_stages = {
	GameStage.STAGE1: {"time": 30, "spawn_time": 2, "spawn_amount": 2, "sapling_time": 3, "harvestable_time": 5},
	GameStage.STAGE2: {"time": 30, "spawn_time": 2, "spawn_amount": 2, "sapling_time": 3, "harvestable_time": 5},
	GameStage.STAGE3: {"time": 60, "spawn_time": 2, "spawn_amount": 3, "sapling_time": 3, "harvestable_time": 5},
	GameStage.STAGE4: {"time": 30, "spawn_time": 2, "spawn_amount": 3, "sapling_time": 3, "harvestable_time": 5}
}

func total_time():
	var time = 0
	for stage in game_stages.values():
		time += stage.time
	return time

enum GameStage {
	STAGE1,
	STAGE2,
	STAGE3,
	STAGE4
}
var game_stage: GameStage = GameStage.STAGE1:
	get:
		return game_stage
	set(new_game_stage):
		var config = game_stages[new_game_stage]
		$GameTimer.start(config.time)
		$PlantSpawnTimer.start(config.spawn_time)
		game_stage = new_game_stage

signal game_over(score)

var rand_generate = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_generate.randomize()
	game_stage = GameStage.STAGE1
	$PlantSpawnTimer.start(PLANT_SPAWN_TIMER)
	$GameTimer.start(game_stages[game_stage].time)
	$TotalTimer.start(total_time())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$GameHUD.set_time_remaining(int($TotalTimer.time_left))


func spawn_plants():
	var config = game_stages[game_stage]
	for i in range(0, config.spawn_amount):
		var plant = PlantScene.instantiate()
		var plant_type = rand_generate.randi_range(0, 2) as Plant.PlantType
		plant.init(plant_type, config.sapling_time, config.harvestable_time)
		var spawn_number = rand_generate.randi_range(1, 75)
		var spawn_point = get_node("Spawns/SpawnPoint" + str(spawn_number))
		plant.global_position = spawn_point.global_position
		add_child(plant)

func _on_plant_spawn_timer_timeout():
	spawn_plants()


func _on_player_harvested_changed(harvested: int):
	$GameHUD.set_harvest_indicator(harvested)


func _on_game_hud_init_hud():
	pass


func _on_game_timer_timeout():
	if game_stage == GameStage.STAGE4:
		emit_signal("game_over", $Player.harvested)
		return
	
	game_stage = (game_stage + 1) as GameStage
	
