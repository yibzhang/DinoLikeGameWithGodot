extends Node2D

var soundLevel = 3

func _ready():
	soundLevel = 3

func _on_Button_pressed():
	if soundLevel > 2:
		soundLevel = 0
	else:
		soundLevel += 1
	$Button.icon = load("res://Icons/sound_level_" + String(soundLevel) + ".png")
	if(soundLevel):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BackgroundMusic"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BackgroundMusic"), -40 + soundLevel*10)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BackgroundMusic"), true)
