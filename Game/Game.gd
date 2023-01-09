extends Node2D

const PlantScene = preload("res://Game/Plant/Plant.tscn")

@export var ZOMBIE_PERCENT = 50
@export var POISON_PERCENT = 25
var zombie_poison = ZOMBIE_PERCENT + POISON_PERCENT

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
	$GameTimer.start(game_stages[game_stage].time)
	$TotalTimer.start(total_time())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$GameHUD.set_time_remaining($TotalTimer.time_left)


func generate_plant_type() -> int:
	var percent = rand_generate.randi_range(0, 100)
	if percent < ZOMBIE_PERCENT:
		return Plant.PlantType.ZOMBIE
	
	if percent < zombie_poison:
		return Plant.PlantType.POISON
	
	return Plant.PlantType.BOMB

var spawn_points: Array = []

func get_spawn_point():
	if spawn_points.is_empty():
		spawn_points = $Spawns.get_children()
		spawn_points.shuffle()
	
	return spawn_points.pop_front()

func spawn_plants():
	var config = game_stages[game_stage]
	for i in range(0, config.spawn_amount):
		var plant = PlantScene.instantiate()
		var plant_type = generate_plant_type() as Plant.PlantType
		plant.init(plant_type, config.sapling_time, config.harvestable_time)
		var spawn_point = get_spawn_point()
		plant.global_position = spawn_point.global_position
		$NavigationRegion2D.add_child(plant)

func _on_plant_spawn_timer_timeout():
	spawn_plants()


func _on_player_harvested_changed(harvested: int):
	$GameHUD.set_harvest_indicator(harvested)


func _on_game_hud_init_hud():
	$GameHUD.init(total_time())
	pass


func _on_game_timer_timeout():
	if game_stage == GameStage.STAGE4:
		emit_signal("game_over", $Player.harvested)
		return
	
	game_stage = (game_stage + 1) as GameStage
	
