extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Start_pressed():
	get_node("Start").move(Vector2(-600, 0))
	get_node("Title").move(Vector2(0, -300))
	get_node("BackToStart").move(Vector2(0, 64))
	get_node("Score").move(Vector2(0, 200))

func _on_BackToStart_pressed():
	get_node("Start").move(Vector2(0, 0))
	get_node("Title").move(Vector2(0, 0))
	get_node("BackToStart").move(Vector2(0, 0))
	get_node("Restart").move(Vector2(0,-100))
	get_node("Score").move(Vector2(0, -200))
