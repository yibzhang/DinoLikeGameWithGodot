extends Node2D

var score = 0;
var animals = ["Horse", "Ox"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Start_pressed():
	start_timer()
	init_player(animals[randi()%animals.size()])

func hit_coin_handle(coinName):
	var player = get_tree().get_nodes_in_group("player");
	if(player[0].name != coinName):
		player[0].swap_free()
		stop_timer()
		stop_enemy_move()
		stop_coin_move()
		free_enemy_before_position(300)
		yield(get_tree().create_timer(1.0), "timeout")
		init_player(coinName)
		yield(get_tree().create_timer(2.0), "timeout")
		start_timer()
		continue_enemy_move()
		continue_coin_move()

func game_over_handle():
	get_node("UI/Menu/Restart").move(Vector2(0, 300))
	stop_timer()
	stop_player_move()
	stop_enemy_move()
	stop_coin_move()

func _on_BackToStart_pressed():
	stop_timer()
	reset_score()
	free_player()
	free_enemy()
	free_coin()
	
func _on_Restart_pressed():
	start_timer()
	reset_score()
	reset_player()
	free_enemy()
	free_coin()
	
func _on_EnemyTimer_timeout():
	spawn_enemy()

func _on_CoinTimer_timeout():
	spawn_coin()

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

func init_player(name):
	# add a new player
	var player = load("res://Scenes/" + name + ".tscn").instance()
	add_child(player)
	# player game_over signal connection
	player.connect("game_over", self, "game_over_handle")
	player.connect("hit_coin", self, "hit_coin_handle")
	player.move(Vector2(200, 502))
	player.gameOver = 0
	if(player.has_method("reset_energy")):
		player.reset_energy()
		
func free_player():
	for player in get_tree().get_nodes_in_group("player"):
		player.queue_free()

func reset_player():
	for player in get_tree().get_nodes_in_group("player"):
		player.move(Vector2(200, 502))
		player.gameOver = 0
		player.get_node("AnimatedSprite").play("run")
		if(player.has_method("reset_energy")):
			player.reset_energy()
			
func stop_player_move():
	for player in get_tree().get_nodes_in_group("player"):
		player.velocity = Vector2(0, 0)

func spawn_enemy():
	var enemy = load("res://Scenes/Enemy.tscn").instance()
	add_child(enemy)
	enemy.position = $EnemySpawnPos.position

func free_enemy():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()

func free_enemy_before_position(x):
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if(enemy.position.x < x):
			enemy.queue_free()

func stop_enemy_move():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.velocity = Vector2(0, 0)

func continue_enemy_move():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.velocity = Vector2(-200, 0)

func spawn_coin():
	var coin = load("res://Scenes/Coin.tscn").instance()
	add_child(coin)
	coin.position = $CoinSpawnPos.position
	coin.set_coin_type(animals[randi()%animals.size()])

func free_coin():
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.queue_free()

func stop_coin_move():
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.velocity = Vector2(0, 0)

func continue_coin_move():
	for coin in get_tree().get_nodes_in_group("coin"):
		coin.velocity = Vector2(-200, 0)

func start_timer():
	$EnemyTimer.start()
	$CoinTimer.start()
	
func stop_timer():
	$EnemyTimer.stop()
	$CoinTimer.stop()
