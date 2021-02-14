extends Area2D

var velocity = Vector2(0,0)

func _ready():
	velocity = Vector2(400,0)

func _process(delta):
	position.x += velocity.x * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_body_entered(body):
	if("enemy" in body.get_groups()):
		body.fire_free()
		get_tree().get_root().get_node("Game").add_score()
