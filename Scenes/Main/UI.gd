extends CanvasLayer

func set_tower_preview(tower_type: String, mouse_position: Vector2, color: Color):
	var drag_tower: Node2D = load("res://Scenes/Towers/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = color
	
	var control: Control = Control.new()
	control.add_child(drag_tower, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(control, 0)

func update_tower_preview(new_position: Vector2, color: Color):
	var control: Control = get_node("TowerPreview")
	control.position = new_position
	if control.get_node("DragTower").modulate != color:
		control.get_node("DragTower").modulate = color


func _on_play_pause_pressed():
	if get_parent().current_wave == 0:
		get_parent().start_next_wave()
	else:
		get_tree().paused = !get_tree().paused


func _on_speed_up_pressed():
	if Engine.time_scale == 1.0:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0
