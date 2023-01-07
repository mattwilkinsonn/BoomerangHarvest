extends CanvasLayer


signal init_hud
# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("init_hud")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func init_health_bar(health: int, max_health: int):
	$VBoxContainer/HealthBar.max_value = max_health	
	$VBoxContainer/HealthBar.value = health
	
func set_health_bar(health: int):
	$VBoxContainer/HealthBar.value = health

func set_harvest_indicator(harvested: int):
	$VBoxContainer/Harvested.text = 'Harvested: ' + str(harvested)
