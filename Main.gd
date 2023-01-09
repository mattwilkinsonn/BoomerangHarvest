extends Node2D

const MainMenuScene = preload("res://Menus/MainMenu.tscn")
const GameOverMenuScene = preload("res://Menus/GameOverMenu.tscn")
const GameScene = preload("res://Game/Game.tscn")

var current_menu
var game
var total_score

# Called when the node enters the scene tree for the first time.
func _ready():
	current_menu = MainMenuScene.instantiate()
	current_menu.play.connect(_on_play)
	add_child.call_deferred(current_menu)
	
func _on_play():
	current_menu.queue_free()
	current_menu = null
	game = GameScene.instantiate()
	game.game_over.connect(_on_game_over)
	add_child.call_deferred(game)
	
func _on_game_over(score):
	total_score = int(score)
	if total_score == 0:
		total_score = get_node("Game/Player.harvested")
	game.queue_free()
	current_menu = GameOverMenuScene.instantiate()
	current_menu.init_menu.connect(init_gameover_menu)
	current_menu.play_again.connect(_on_play)
	add_child.call_deferred(current_menu)

func init_gameover_menu():
	current_menu.init(total_score)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
