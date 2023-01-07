extends Node2D


const PlantScene = preload("res://Game/Plant.tscn")

@export var PLANTS_TO_SPAWN = 2

signal game_over(score)

var rand_generate = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_generate.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var time_left = int($GameTimer.time_left)
	$GameHUD.set_time_remaining(time_left)
	
func _on_plant_spawn_timer_timeout():
	for i in range(0, PLANTS_TO_SPAWN):
		var plant = PlantScene.instantiate()
		var x = rand_generate.randi_range(10, 1270)
		var y = rand_generate.randi_range(10, 710)
		plant.global_position = Vector2(x, y)
		add_child(plant)

func _on_player_harvested_changed(harvested: int):
	$GameHUD.set_harvest_indicator(harvested)

func _on_game_hud_init_hud():
	pass


func _on_game_timer_timeout():
	emit_signal("game_over", $Player.harvested)
