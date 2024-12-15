extends TileMap

#TODO: add map of live cells for performance
#FIXME: fix need to copy matrix down

@export var isRunnin: bool = false
var mouse_pos: Vector2
var last_mouse_pos: Vector2
@onready var w_size: Vector2 = get_window().size

var frame_count: int = 0

func count_all(i: int, j: int):
	var counter: int = 0
	if get_cell_source_id(0, Vector2i(i + 1, j)) == 2:
		counter += 1
	if get_cell_source_id(0, Vector2i(i + 1, j + 1)) == 2:
		counter += 1
	if get_cell_source_id(0, Vector2i(i, j + 1)) == 2:
		counter += 1
	if get_cell_source_id(0, Vector2i(i - 1, j + 1)) == 2:
		counter += 1
	if get_cell_source_id(0, Vector2i(i - 1, j)) == 2:
		counter += 1
	if get_cell_source_id(0, Vector2i(i - 1, j - 1)) == 2:
		counter += 1
	if get_cell_source_id(0, Vector2i(i, j - 1)) == 2:
		counter += 1
	if get_cell_source_id(0, Vector2i(i + 1, j - 1)) == 2:
		counter += 1
	return counter

func proc_life():
	for i in range(1, w_size.x):
		for j in range(1, w_size.y):
			#if (i > 0 and i < w_size.x) and (j > 0 and j < w_size.y):
				var counter: int = count_all(i, j)
				if get_cell_source_id(0, Vector2i(i, j)) == 2 and counter < 2:
					set_cell(1, Vector2i(i, j), 0, Vector2(0, 0))
				elif get_cell_source_id(0, Vector2i(i, j)) == 2 and counter > 3:
					set_cell(1, Vector2i(i, j), 0, Vector2(0, 0))
				elif get_cell_source_id(0, Vector2i(i, j)) == 0 and counter == 3:
					set_cell(1, Vector2i(i, j), 2, Vector2(0, 0))
				else:
					pass

func copy_layer():
	for i in w_size.x:
		for j in w_size.y:
			set_cell(0, Vector2i(i, j), get_cell_source_id(1, Vector2i(i, j)), Vector2(0, 0))

# Called when the node enters the scene tree for the first time.
func _ready():
	clear()
	for i in w_size.x:
		for j in w_size.y:
			set_cell(0, Vector2(i, j), 0, Vector2(0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("play"):
		clear_layer(1)
		isRunnin = !isRunnin
	if isRunnin:
		if frame_count == 5:
			frame_count = 0
		if frame_count == 0:
			proc_life()
			copy_layer()
			clear_layer(1)
		frame_count += 1
	else:
		mouse_pos = local_to_map(get_local_mouse_position())
		set_cell(1, mouse_pos, 1, Vector2(0, 0))
		if mouse_pos != last_mouse_pos:
			set_cell(1, last_mouse_pos, -1, Vector2(0, 0))
		last_mouse_pos = mouse_pos
		if Input.is_action_just_pressed("press"):
			if get_cell_source_id(0, mouse_pos) == 2:
				set_cell(0, mouse_pos, 0, Vector2(0, 0))
			else:
				set_cell(0, mouse_pos, 2, Vector2(0, 0))
			clear_layer(1)
	pass
