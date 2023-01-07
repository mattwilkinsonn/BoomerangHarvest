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
	pass


func _on_plant_spawn_timer_timeout():
	for i in range(0, PLANTS_TO_SPAWN):
		var plant = PlantScene.instantiate()
		var x = rand_generate.randi_range(10, 1270)
		var y = rand_generate.randi_range(10, 710)
		plant.global_position = Vector2(x, y)
		add_child(plant)


func _on_player_health_changed(health: int):
	if health <= 0:
		emit_signal("game_over", $Player.harvested)
	$GameHUD.set_health_bar(health)



func _on_player_harvested_changed(harvested: int):
	$GameHUD.set_harvest_indicator(harvested)


func _on_game_hud_init_hud():
	$GameHUD.init_health_bar($Player.health, $Player.MAX_HEALTH)
