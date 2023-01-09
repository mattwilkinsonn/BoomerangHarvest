extends CharacterBody2D

@export var MOVEMENT_SPEED = 150.0
@export var LIFE_TIME = 5.0
@export var DELAYED_DEATH_TIME = 0.001

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

const PlantDeathScene = preload("res://Game/Plant/PlantDeath.tscn")

var player

func _ready():
	player = get_node("../../Player")
	$DeathTimer.start(LIFE_TIME)
	
	# these values need to be adjusted for the actor's speed
	# and the navpolygon layout as each crossed edge will create a path point
	# If the actor moves to fast it might overshoot
	# multiple path points in one frame and start to backtrack
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	# make a deferred function call to assure the entire Scenetree is loaded
	call_deferred("actor_setup")
	
func set_movement_target(movement_target : Vector2):
	navigation_agent.set_target_location(movement_target)

func actor_setup():
	# wait for the first physics frame so the NavigationServer can sync
	await get_tree().physics_frame

func flip(x_direction: float):
	$AnimatedSprite2D.flip_h = x_direction < 0
	

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	flip(direction.x)
	set_movement_target(player.global_position)
	
	var current_agent_position : Vector2 = global_transform.origin
	var next_path_position : Vector2 = navigation_agent.get_next_location()

	var new_velocity : Vector2 = next_path_position - current_agent_position
	velocity = new_velocity.normalized() * MOVEMENT_SPEED

	move_and_slide()

func delayed_death():
	$DeathTimer.start(DELAYED_DEATH_TIME)

func _on_death_timer_timeout():
	death()

func death():
	var plant_death = PlantDeathScene.instantiate()
	plant_death.global_position = global_position
	get_parent().add_child.call_deferred(plant_death)
	queue_free()


func _on_gameplay_collider_area_entered(area):
	if area.get_parent() == player:
		player.bump(global_position.direction_to(player.global_position), Player.BumpType.NUDGE)
