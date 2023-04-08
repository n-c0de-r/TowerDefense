extends Node2D

var type: String
var enemies: Array[PathFollow2D] = []
var built: bool = false
var canFire = true

func _ready():
	if built:
		self.get_node("Range/Shape").shape.radius = Towers.DATA[type]["range"]

func _physics_process(_delta):
	if enemies.size() > 0 and built:
		var enemy: PathFollow2D = select_enemy(enemies)
		turn(enemy.position)
		if canFire:
			fire(enemy)

func fire(enemy: PathFollow2D):
	canFire = false
	enemy.on_hit(Towers.DATA[type]["damage"])
	await get_tree().create_timer(Towers.DATA[type]["delay"]).timeout
	canFire = true

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
	get_node("Turret").look_at(enemy_position)

func _on_range_body_entered(body: CharacterBody2D):
	enemies.append(body.get_parent())

func _on_range_body_exited(body: CharacterBody2D):
	enemies.erase(body.get_parent())
