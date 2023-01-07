extends Node2D

const MainMenu = preload("res://Menus/MainMenu.tscn")
const Game = preload("res://Game/Game.tscn")

var current_menu
var game

# Called when the node enters the scene tree for the first time.
func _ready():
	current_menu = MainMenu.instantiate()
	current_menu.play.connect(_on_play)
	add_child(current_menu)
	
func _on_play():
	current_menu.queue_free()
	game = Game.instantiate()
	add_child(game)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
