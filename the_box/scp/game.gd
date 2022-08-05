extends Node2D

#Game script .............................

onready var camera = Global.camera
onready var tween = $Tween
var fell_speed = 800

var on_game = false

var c_rot = 0

func _enter_tree():
	Global.game = self

func _input(event):
	if on_game:
		if !Global.player.lose:
			if Input.is_action_just_pressed("left"):
				rot(1)
			if Input.is_action_just_pressed("right"):
				rot(-1)
			if event is InputEventMouseMotion:
				if event.relative.x >= 20:
					rot(1)
				if event.relative.x <= -20:
					rot(-1)

func rot(dir):
	if tween.is_active():return
	if c_rot >= 360: 
		c_rot = 0
		camera.rotation_degrees = 0
	if c_rot < 0:
		c_rot = 270
		camera.rotation_degrees = 270
	c_rot += 90*dir
	tween.interpolate_property(camera,"rotation_degrees",null,c_rot,0.7)
	tween.start()
	match c_rot:
		0,360:
			Global.player.applied_force = Vector2.DOWN*fell_speed
		90:
			Global.player.applied_force = Vector2.LEFT*fell_speed
		180:
			Global.player.applied_force = Vector2.UP*fell_speed
		270,-90:
			Global.player.applied_force = Vector2.RIGHT*fell_speed
