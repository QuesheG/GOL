extends Node2D

@export var isRunnin: bool = false
var frame_count: int = 0

var mouse_pos: Vector2
var last_mouse_pos: Vector2

@onready var tex_size: int  = load("res://black_cell.png").get_size().x
@onready var win_size: Vector2i = get_window().size / 5
var mat_calc: Array[Array]
var mat_cpy: Array[Array]

@onready var cam: Camera2D = $"../Camera2D"
@onready var calc: TileMapLayer = $"../Calc"
@onready var preview: TileMapLayer = $"../Preview"

var chang: Array[Vector2i]

@onready var fps_text := %FPS_text

func get_wrapped(x: int, y: int) -> int:
	var i = (x + win_size.x) % win_size.x
	var j = (y + win_size.y) % win_size.y
	return mat_calc[i][j]

func count_all(i: int, j: int) -> int:
	var counter: int = 0
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			if dx or dy: counter += get_wrapped(i + dx, j + dy)
	return counter

func proc_life() -> void:
	for i in win_size.x:
		for j in win_size.y:
			var counter: int = count_all(i, j)
			if mat_calc[i][j] and counter < 2:
				mat_cpy[i][j] = 0
				chang.append(Vector2i(i,j))
			elif mat_calc[i][j] and counter > 3:
				mat_cpy[i][j] = 0
				chang.append(Vector2i(i,j))
			elif mat_calc[i][j] == 0 and counter == 3:
				mat_cpy[i][j] = 1
				chang.append(Vector2i(i,j))
			elif mat_calc[i][j]:
				mat_cpy[i][j] = 1

func update_mat() -> void:
	#for i in range(win_size.x):
		#for j in range(win_size.y):
			#if mat_calc[i][j] != mat_cpy[i][j]:
				#mat_calc[i][j] = mat_cpy[i][j]
	for pos in chang:
		mat_calc[pos.x][pos.y] = mat_cpy[pos.x][pos.y]

func update_draw() -> void:
	#for i in range(win_size.x):
		#for j in range(win_size.y):
			#if mat_calc[i][j] != calc.get_cell_source_id(Vector2i(i,j)):
				#calc.set_cell(Vector2i(i,j), mat_calc[i][j], Vector2i(0,0))
	while not chang.is_empty():
		var pos: Vector2i = chang.pop_front()
		calc.set_cell(pos, mat_calc[pos.x][pos.y], Vector2i(0,0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam.zoom.x = get_viewport_rect().size.x/(win_size.x * tex_size)
	cam.zoom.y = cam.zoom.x
	cam.offset = win_size * 64
	for i in range(win_size.x):
		mat_calc.append([])
		mat_cpy.append([])
		for j in range(win_size.y):
			var c_a_i = randi() % 2 
			calc.set_cell(Vector2i(i,j), c_a_i, Vector2i(0,0))
			mat_calc[i].append(c_a_i)
			mat_cpy[i].append(c_a_i)

func frame_helper() -> void:
	if frame_count == 5:
		frame_count = 0
	if frame_count == 0:
		proc_life()
	if frame_count == 2:
		update_mat()
	if frame_count == 4:
		update_draw()
	frame_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps_text.text = "FPS: " + str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("play"):
		isRunnin = !isRunnin
		#preview.clear()
	if isRunnin:
		frame_helper()
		#proc_life()
		#update_mat()
		#update_draw()
	#else:
		#mouse_pos = get_global_mouse_position()
		#if mouse_pos != last_mouse_pos:
			#preview.set_cell(preview.local_to_map(last_mouse_pos), -1, Vector2i(0,0))
			#preview.set_cell(preview.local_to_map(mouse_pos), 2, Vector2i(0,0))
		#last_mouse_pos = mouse_pos
		#if Input.is_action_just_pressed("press"):
			#var res = not calc.get_cell_source_id(calc.local_to_map(mouse_pos))
			#res = int(res)
			#calc.set_cell(calc.local_to_map(mouse_pos), res, Vector2(0,0))
			#mat_calc[calc.local_to_map(mouse_pos).x][calc.local_to_map(mouse_pos).y] = res
