extends Camera2D

var mouse_pos: Vector2
var last_mouse_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		mouse_pos = get_local_mouse_position()
		if mouse_pos != last_mouse_pos:
			position += (mouse_pos - last_mouse_pos)
		last_mouse_pos = mouse_pos
	pass
