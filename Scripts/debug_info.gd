extends CanvasLayer

var update_timer = Timer.new()
@onready var player = get_node("../debug_info/label")

func _ready() -> void:
	_update_fps()
	
	update_timer.timeout.connect(_update_fps)
	update_timer.wait_time = 1
	add_child(update_timer)
	update_timer.start()

func _update_fps() -> void:
	var fps_counter = Engine.get_frames_per_second()
	$label.set_text(
		"FPS: " + str(
			int(fps_counter)
		)
	)
