extends CharacterBody2D

@onready var turret = $Turret

@export var projectile_scene: PackedScene
@onready var shoot_point = $Turret/ShootPoint
@onready var reload_timer = $Turret/ReloadTimer

@export var start_move_direction: Vector2 = Vector2.DOWN
@export var move_speed: float = 20.0
@export var body_rotation_speed: float = 0.5
@export var turret_rotation_speed: float = 0.8

var move_direction: Vector2 = Vector2.ZERO

var detected_targets: Array[Node2D] = []
var current_target: Node2D = null
var distance_to_target

func _ready() -> void:
	var angle_to_start = global_position.angle_to_point(start_move_direction)
	rotate(angle_to_start)

func _physics_process(delta: float) -> void:
	current_target = get_target()
	
	if current_target == null:
		move_direction = start_move_direction
		velocity = move_direction * move_speed
		var idle_rotation_angle = start_move_direction.angle() + PI/2
		body_rotation(idle_rotation_angle, delta)
		turret_rotation(idle_rotation_angle, delta)
	else:
		distance_to_target = global_position.distance_to(current_target.global_position)
		move_direction = global_position.direction_to(current_target.global_position)
		var body_angle = global_position.angle_to_point(current_target.global_position) + PI/2
		var turret_angle = turret.global_position.angle_to_point(current_target.global_position) + PI/2
		body_rotation(body_angle, delta)
		turret_rotation(turret_angle, delta)
		shoot_and_reload()
		handle_velocity_in_combat()
		#velocity = move_direction * move_speed
	
	move_and_slide()


func get_target():
	var closest_target: Node2D = null
	var closest_dist: float = INF
	
	for t in detected_targets:
		if !is_instance_valid(t):
			continue
		var dist = global_position.distance_to(t.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_target = t
	
	return closest_target


func body_rotation(angle_to_target: float, delta: float) -> void:
	#var angle_to_target = global_position.angle_to_point(rotation_target.global_position) + PI/2
	#global_rotation = rotate_toward(global_rotation, angle_to_target, body_rotation_speed * delta)
	global_rotation = rotate_toward(global_rotation, angle_to_target, body_rotation_speed * delta)


func turret_rotation(angle_to_target: float, delta: float) -> void:
	#var angle_to_target = turret.global_position.angle_to_point(rotation_target.global_position) + PI/2
	#turret.global_rotation = rotate_toward(turret.global_rotation, angle_to_target, turret_rotation_speed * delta)
	turret.global_rotation = rotate_toward(turret.global_rotation, angle_to_target, turret_rotation_speed * delta)

func handle_velocity_in_combat():
	if distance_to_target >= 500:
		velocity = move_direction * move_speed
	else:
		velocity = -move_direction * move_speed

func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = shoot_point.global_position
	projectile.global_rotation = shoot_point.global_rotation
	projectile.launch(-shoot_point.global_transform.y)


func shoot_and_reload() -> void:
	if reload_timer.is_stopped():
		shoot()
		reload_timer.start()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") || body.is_in_group("allies"):
		if !detected_targets.has(body):
			detected_targets.append(body)


func _on_detection_area_body_exited(body: Node2D) -> void:
	detected_targets.erase(body)
