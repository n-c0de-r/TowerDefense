extends PathFollow2D

var speed = 150
var health = 50

@onready var health_bar: TextureProgressBar = get_node("HealthBar")

func _ready():
	health_bar.max_value = health
	health_bar.value = health
	health_bar.top_level = true 

func _physics_process(delta):
	move(delta)

func move(delta):
	progress += speed * delta
	health_bar.position = position - Vector2(30, 30)

func on_hit(damage: float):
	health -= damage
	health_bar.value = health
	if health <= 0:
		self.queue_free()
