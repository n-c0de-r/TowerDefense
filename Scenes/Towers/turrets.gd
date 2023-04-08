extends Node2D

var enemies: Array[PathFollow2D] = []
var built: bool = false

func _ready():
	if built:
		self.get_node("Range/Shape").shape.radius = Towers.DATA[self.name.split("(")[0]]["range"]

func _physics_process(_delta):
	if enemies.size() > 0 and built:
		var pos: Vector2 = select_enemy(enemies).position
		turn(pos)

func select_enemy(array: Array[PathFollow2D]) -> PathFollow2D:
	var index: int = 0
	var max_index: int = 0
	var max: float = 0.0
	for i in array:
		if i.progress > max:
			max = i.progress
			max_index = index
		index += 1
	return array[max_index]

func turn(enemy_position: Vector2) -> void:
#	var enemey_pos: Vector2 = get_global_mouse_position()
	get_node("Turret").look_at(enemy_position)

func _on_range_body_entered(body: CharacterBody2D):
	enemies.append(body.get_parent())

func _on_range_body_exited(body: CharacterBody2D):
	enemies.erase(body.get_parent())
