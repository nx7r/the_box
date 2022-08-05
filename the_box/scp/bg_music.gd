extends AudioStreamPlayer



var m = load("res://assets/music.ogg")

func _ready():
	stream = m
	volume_db = -10
	play()
