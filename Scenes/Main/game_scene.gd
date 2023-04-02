extends Node2D

var map_node: Node2D
var ui: CanvasLayer
var map: TileMap
var roads: Array[Vector2i]
var props: Array[Vector2i]

var build_mode_active: bool = false
var valid_build_position: bool = false
var build_location: Vector2
var build_type: String

func _ready():
	map_node = get_node("Map1") #TODO Map switching
	map = map_node.get_node("GroundMap")
	roads = map.get_used_cells(1)
	props = map.get_used_cells(2)
	ui = get_node("UI")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", initiate_build_mode_active.bind(i.get_name()))

func _process(delta):
	if build_mode_active:
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode_active:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode_active:
		verify_and_build(build_location)
		cancel_build_mode()

func initiate_build_mode_active(tower_type: String):
	build_type = tower_type + "T1"
	build_mode_active = true
	ui.set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position: Vector2 = get_global_mouse_position()
	var tile_coords: Vector2i = map.local_to_map(mouse_position)
	var tile_position: Vector2 = map.map_to_local(tile_coords)
	
	if(!roads.has(tile_coords) and !props.has(tile_coords)):
		ui.update_tower_preview(tile_position, "54ff3cad")
		valid_build_position = true
		build_location = tile_position
	else:
		ui.update_tower_preview(tile_position, "ff4545ad")
		valid_build_position = false

func cancel_build_mode():
	build_mode_active = false
	valid_build_position = false
	get_node("UI/TowerPreview").queue_free()

func verify_and_build(new_location: Vector2):
	if valid_build_position:
		## TODO check cash
		var new_tower: Node2D = load("res://Scenes/Towers/" + build_type + ".tscn").instantiate()
		new_tower.position = new_location
		map_node.get_node("TowerContainer").add_child(new_tower, true)
		props.append(map.local_to_map(new_location))
		## TODO reduce cash
		## TODO Update label
