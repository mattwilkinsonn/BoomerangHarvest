extends CanvasLayer

signal init_hud


# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("init_hud")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_time_remaining(seconds: int):
	var minutes = seconds / 60
	var seconds_after = seconds % 60
	$VBoxContainer/TimeRemaining.text = "Time Remaining " + seconds_to_output(seconds)
	
func seconds_to_output(seconds: int):
	var minutes = seconds / 60
	var seconds_after = seconds % 60
	
	if minutes <= 0:
		return str(seconds)
	
	var middle_part = ":"
	if seconds_after < 10:
		middle_part += "0"
	
	return str(minutes) + middle_part + str(seconds_after)
	


func set_harvest_indicator(harvested: int):
	$VBoxContainer/Harvested.text = "Harvested " + str(harvested)
