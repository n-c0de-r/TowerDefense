extends Node2D

func _physics_process(_delta):
	turn()

func turn():
	var enemey_pos: Vector2 = get_global_mouse_position()
	get_node("Turret").look_at(enemey_pos)
