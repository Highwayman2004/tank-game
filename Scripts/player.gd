extends CharacterBody2D

@export var movement_speed = 100.0
@export var rotation_speed = 0.5
@export var speed_up_movement = 10
@export var speed_up_rotation = 0.05

@onready var turret = $Turret
@export var projectile_scene: PackedScene
@onready var shoot_point = $Turret/ShootPoint
@onready var reload_timer = $Turret/ReloadTimer

@export var reload_time: float = 1.0

@export var start_direction = Vector2.UP

var starting_move_speed
var starting_rotate_speed

func _ready() -> void:
	starting_move_speed = movement_speed
	starting_rotate_speed = rotation_speed
	var start_angle = start_direction.angle() + PI/2
	global_rotation = start_angle
	turret.global_rotation = start_angle

func _physics_process(delta: float) -> void:
	var movement_direction = Input.get_axis("move_backward", "move_forward")
	var rotation_direction = Input.get_axis("turn_left", "turn_right")
	
	set_speed()
	
	velocity = -transform.y * movement_direction * movement_speed
	
	if movement_direction < 0:
		rotation_direction *=-1
	
	rotation += rotation_direction * rotation_speed * delta
	
	_turret_rotation()
	
	if Input.is_action_just_pressed("shoot") and reload_timer.is_stopped():
		_shoot()
		reload_timer.start()
	
	move_and_slide()


func _turret_rotation():
	var cursor_location = get_global_mouse_position()
	var angle_rotation = global_position.angle_to_point(cursor_location) + PI /2
	
	turret.global_rotation = angle_rotation

func set_speed():
	#var sped_up_movement
	#var sped_up_rotation
	if not Input.is_action_pressed("speed_up"):
		movement_speed = starting_move_speed
		#sped_up_rotation = starting_rotate_speed
		#rotation_speed = speed_up_rotation
	else:
		movement_speed += speed_up_movement
		#sped_up_rotation = rotation_speed + speed_up_rotation
		#rotation_speed = sped_up_movement
	
	

func _shoot():
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = shoot_point.global_position
	projectile.global_rotation = shoot_point.global_rotation
	projectile.launch(-shoot_point.global_transform.y)
