extends Area2D

@export var initial_velocity = 300.0
@export var speed := 600.0

var direction = Vector2.ZERO

func launch(move_direction: Vector2):
	direction = move_direction.normalized()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
