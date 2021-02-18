extends Area2D

var velocity = Vector2(0,0)

func _ready():
	velocity = Vector2(400,0)

func _process(delta):
	position.x += velocity.x * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_body_entered(body):
	if("boss" in body.get_groups()):
		body.get_hit()
		queue_free()
	
	if("enemy" in body.get_groups()):
		body.hit_free($AnimatedSprite.animation)
		get_tree().get_root().get_node("Game").add_score()
