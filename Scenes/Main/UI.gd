extends CanvasLayer

func set_tower_preview(tower_type: String, mouse_position: Vector2):
	var drag_tower: Node2D = load("res://Scenes/Towers/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("54ff3cad")
	
	var control: Control = Control.new()
	control.add_child(drag_tower, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(control, 0)

func update_tower_preview(new_position: Vector2, color: String):
	var control: Control = get_node("TowerPreview")
	control.position = new_position
	if control.get_node("DragTower").modulate != Color(color):
		control.get_node("DragTower").modulate = Color(color)
