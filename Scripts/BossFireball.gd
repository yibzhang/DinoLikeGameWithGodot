extends Area2D

var velocity = Vector2(0,0)

func _ready():
	velocity = Vector2(400,0)

func _process(delta):
	position.x -= velocity.x * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_BossFireball_body_entered(body):
	if("player" in body.get_groups()):
		body.boss_fireball_hit()
		queue_free()
