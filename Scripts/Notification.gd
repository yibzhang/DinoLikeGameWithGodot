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
func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, 2, Tween.TRANS_QUINT, Tween.EASE_OUT);
	move_tween.start()

func start_timer():
	$Timer.start()

func move_in():
	move(Vector2(360,200))

func move_out():
	move(Vector2(1100,200))

func _on_Timer_timeout():
	move_out()
	$Timer.stop()

func reset():
	position = Vector2(-350, 200)
