extends Node2D

var score = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	# enemy spawn counter starts
	$EnemyTimer.start()
	# add a new player
	var player = load("res://Scenes/Ox.tscn").instance()
	add_child(player)
	# move player in the screen
	player.move(Vector2(200, 502))
	# player game_over signal connection
	player.connect("game_over", self, "game_over_handle")

func game_over_handle():
	# move game restart button in the screen
	get_node("UI/Menu/Restart").move(Vector2(0, 300))
	# stop enemy spawn counter
	$EnemyTimer.stop()
	# stop all enemies move
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.velocity.x = 0

func _on_BackToStart_pressed():
	# stop enemy spawn counter
	$EnemyTimer.stop()
	# reset score
	reset_score()
	# free all enemy and player
	for child in get_children():
		if "enemy" in child.get_groups() or "player" in child.get_groups():
			child.queue_free()

func _on_EnemyTimer_timeout():
	# Enemy spawn while counter timeout reaches
	var enemy = load("res://Scenes/Enemy.tscn").instance()
	add_child(enemy)
	enemy.position = $EnemySpawnPos.position

func _on_Restart_pressed():
	# player moves back out of screen
	for player in get_tree().get_nodes_in_group("player"):
		player.move(Vector2(200, 502))
		player.gameOver = 0
	# reset score
	reset_score()
	# free all enemy
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	# start enemy spawn counter
	$EnemyTimer.start()

func _on_Scoreboard_body_entered(body):
	# if enemy hits scoreboard, add a score
	if("enemy" in body.get_groups()):
		add_score()

func add_score():
	score += 1;
	update_score()

func reset_score():
	score = 0
	update_score()
	
func update_score():
	get_node("UI/Menu/Score/Label").text = str(score)	
