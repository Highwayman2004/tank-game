extends Camera2D

@export var startingZoom = 1.0
@export var maxZoomIn = 5.0
@export var maxZoomOut = 0.5

func _ready() -> void:
	zoom = Vector2(startingZoom,  startingZoom)

func _process(delta: float) -> void:
	_change_camera_zoom()

func _change_camera_zoom():
	if Input.is_action_just_pressed("camera_zoom_in") and Vector2(zoom.x, zoom.y) < Vector2(maxZoomIn, maxZoomIn):
		zoom.x += 0.5
		zoom.y += 0.5
	
	if Input.is_action_just_pressed("camera_zoom_out") and Vector2(zoom.x, zoom.y) > Vector2(maxZoomOut, maxZoomOut):
		zoom.x -= 0.5
		zoom.y -= 0.5
