extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	get_node("Player").move(Vector2(200, 502))

func _on_BackToStart_pressed():
	get_node("Player").move(Vector2(-100, 502))


func _on_EnemyTimer_timeout():
	pass
