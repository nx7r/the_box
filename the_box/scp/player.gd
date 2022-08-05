extends RigidBody2D

#Player script .............................

onready var game = get_parent()
onready var main = Global.main
var lose = false
var win = false

func _enter_tree():
	Global.player = self

func _on_body_entered(body):
	if body.collision_layer == 4 && !win && !lose && game.on_game:
		destroy_me()
	if body.collision_layer == 8 && !win && !lose && game.on_game:
		_win()

func destroy_me():
	lose = true
	game.on_game = false
	applied_force = Vector2.ZERO
	applied_torque = 0
	Engine.time_scale = 0.4
	$Sprite.hide()
	main.lose()
func _win():
	win = true
	applied_force = Vector2.ZERO
	applied_torque = 0
	Engine.time_scale = 0.4
	main.win()
