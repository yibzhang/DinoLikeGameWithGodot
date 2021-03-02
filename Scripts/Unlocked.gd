extends Node2D

func _ready():
	pass # Replace with function body.

func update_unlocked(animalsList):
	free_unlocked()
	for i in range(animalsList.size()):
		var unlocked = load("res://Scenes/Unlocked.tscn").instance()
		unlocked.play(animalsList[i])
		unlocked.position = Vector2(120 + 40*i, 20)
		add_child(unlocked)

func free_unlocked():
	for unlocked in get_tree().get_nodes_in_group("unlocked"):
		unlocked.free()
