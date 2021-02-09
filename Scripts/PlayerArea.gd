extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Player_body_entered(body):
	if("enemy" in body.get_groups()):
		emit_signal("game_over")
