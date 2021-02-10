extends KinematicBody2D


var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = -200;

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if "player" in collision.collider.get_groups():
			velocity = Vector2(0, 0)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func set_coin_type(animal):
	$AnimatedSprite.play(animal)