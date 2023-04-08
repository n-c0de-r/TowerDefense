extends Node2D

var map_node: Node2D
var ui: CanvasLayer
var map: TileMap
var roads: Array[Vector2i]
var props: Array[Vector2i]

var build_mode_active: bool = false
var valid_build_position: bool = false
var build_location: Vector2 = Vars.RESET_POSITION
var build_type: String
var overlay_color: Color

var current_wave: int = 0
var enemies_in_wave: int = 0


func _ready():
	map_node = get_node("Map1") #TODO Map switching
	map = map_node.get_node("GroundMap")
	roads = map.get_used_cells(1)
	props = map.get_used_cells(2)
		
	ui = get_node("UI")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", initiate_build_mode_active.bind(i.get_name()))

func _process(_delta):
	queue_redraw()
	if build_mode_active:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode_active:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode_active:
		verify_and_build(build_location)
		cancel_build_mode()


func _draw():
	draw_circle(build_location, 100, overlay_color)
	var arcColor: Color
	if(overlay_color == Vars.HALF_GREEN):
		arcColor = Vars.GREEN
	else:
		arcColor = Vars.RED
	draw_arc(build_location, 100, 0, 360, 100, arcColor)

##
## Building Functions
##
func initiate_build_mode_active(tower_type: String):
	if build_mode_active:
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode_active = true
	ui.set_tower_preview(build_type, get_global_mouse_position(), overlay_color)


func update_tower_preview():
	var mouse_position: Vector2 = get_global_mouse_position()
	var tile_coords: Vector2i = map.local_to_map(mouse_position)
	var tile_position: Vector2 = map.map_to_local(tile_coords)
	build_location = tile_position
	
	valid_build_position = check_build_position(tile_coords)
	# Somehow this executes exactly in reverse!
	if(!valid_build_position):
		overlay_color = Vars.HALF_GREEN
	else:
		overlay_color = Vars.HALF_RED
		
	ui.update_tower_preview(tile_position, overlay_color)


func cancel_build_mode():
	build_mode_active = false
	valid_build_position = false
	build_location = Vars.RESET_POSITION
	get_node("UI/TowerPreview").free()


func verify_and_build(new_location: Vector2):
	if valid_build_position:
		## TODO check cash
		var new_tower: Node2D = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate()
		new_tower.position = new_location
		var coords: Vector2i = map.local_to_map(new_location)
		new_tower.set_name(build_type + str(coords))
		map_node.get_node("TowerContainer").add_child(new_tower, true)
		props.append(coords)
		## TODO reduce cash
		## TODO Update label


func check_build_position(coords: Vector2i) -> bool:
	return !roads.has(coords) and !props.has(coords)

##
## Wave Functions
##
func start_next_wave():
	var wave_data = retrieve_wave_data()
	current_wave += 1
	await get_tree().create_timer(0.3).timeout
	spawn_enemies(wave_data)

func retrieve_wave_data() -> Array:
	var wave_data = [["BlueTank", 0.7], ["BlueTank", 0.1]]
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/"+ i[0] + ".tscn").instantiate()
		map_node.get_node("Path").add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout
