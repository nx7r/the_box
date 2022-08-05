extends Camera2D

#Camera script .............................

export var max_distance:Vector2 = Vector2(20,50)
export var lose_zoom_value:Vector2 = Vector2(0.4,0.4)
onready var Game = Global.game

func _enter_tree():
	Global.bg = $BG
	Global.camera = self

func _physics_process(_delta):
	if !is_instance_valid(Global.player):return
	if Game.on_game:
		if position.distance_to(Global.player.position) >= max_distance.length():
			position = lerp(position,Global.player.position,0.7)
	if Global.player.lose or Global.player.win:
		zoom = lerp(zoom,lose_zoom_value,0.1)
