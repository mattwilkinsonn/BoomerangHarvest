extends CanvasLayer

signal init_hud


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("init_hud")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_time_remaining(seconds: int):
	$VBoxContainer/TimeRemaining.text = "Time Remaining: " + str(seconds)


func set_harvest_indicator(harvested: int):
	$VBoxContainer/Harvested.text = "Harvested: " + str(harvested)
