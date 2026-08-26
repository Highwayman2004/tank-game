extends Node2D

@export var player: Node2D
@export var player_spawn_position: Node2D

@export var ally_scene: PackedScene
@export var ally_spawn: PathFollow2D
@export var ally_spawn_timer: Timer
@export var allies_to_spawn = 2

@export var enemy_scene: PackedScene
@export var enemy_spawn: PathFollow2D
@export var enemy_spawn_timer: Timer
@export var enemies_to_spawn = 2

func _ready() -> void:
	spawn_player()


func _process(delta: float) -> void:
	pass


func spawn_player():
	player.position = player_spawn_position.position
	if !player.is_in_group("player"):
		player.add_to_group("player")


func spawn_ally():
	var ally = ally_scene.instantiate()
	ally_spawn.progress_ratio = randf()
	ally.position = ally_spawn.position
	add_child(ally)
	ally.add_to_group("allies")
	allies_to_spawn -= 1


func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy_spawn.progress_ratio = randf()
	enemy.position = enemy_spawn.position
	add_child(enemy)
	enemy.add_to_group("enemies")
	enemies_to_spawn -= 1


func _on_start_timer_timeout() -> void:
	ally_spawn_timer.start()
	enemy_spawn_timer.start()


func _on_ally_spawn_timer_timeout() -> void:
	if allies_to_spawn > 0:
		spawn_ally()
	else:
		ally_spawn_timer.stop()


func _on_enemy_spawn_timer_timeout() -> void:
	if enemies_to_spawn > 0:
		spawn_enemy()
	else:
		enemy_spawn_timer.stop()
