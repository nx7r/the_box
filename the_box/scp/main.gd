extends Node

#Main script .............................
export var player_initial_position:Vector2 = Vector2(32,-32)

var main = load("res://scn/main.tscn")
var _menu_show = load("res://res/MenuShow.res")
var player = load("res://res/player.res")
var pb = load("res://res/progress.res")
var explosion = load("res://res/Explosion.res")

var crt_lvl = 0
var ad_l
var on_load = false
var _pb
var _player = null

onready var bg:Node = Global.bg
onready var bg_tween:Tween = $"Bg Tween"
onready var tween:Tween = $Tween
onready var on_game_bar:Node = $UI/on_game_bar
onready var ui:Node = $UI/main_ui
onready var boxs_l:Node = $UI/main_ui/main_menu/boxs 
onready var b_anim:Node = $UI/main_ui/main_menu/anim
onready var win_l:Node = $UI/win
onready var lvls_l:Node = $UI/main_ui/main_menu/ScrollContainer
onready var lose_l:Node = $UI/lose
onready var menu:Node = $UI/main_ui/main_menu
onready var menu_show:Node = $Game/MenuShow
onready var game:Node = $Game
onready var canvas_bg:Node = $BG/bg

func _ready():
	Global.load_banner()
	sync_boxs()

func set_color():
	var color = Color(rand_range(0.01,0.5),rand_range(0.01,0.5),rand_range(0.1,0.6))
	bg_tween.interpolate_property(bg,"color",null,color,0.5)
	bg_tween.interpolate_property(canvas_bg,"color",null,color,0.5)
	bg_tween.start()


func hide_ui(duration:float):
	tween.interpolate_property(ui,"modulate",null,Color.transparent,duration)
	if is_instance_valid(menu_show):tween.interpolate_property(menu_show,"modulate",null,Color.transparent,0.4)
	tween.start()
	hide_node([ui])
	

func load_lvl(id):
	if Global.boxs < 1:
		no_enough_boxs()
		return
	if on_load:return
	on_load = true
	if !ResourceLoader.exists(Global.levels[id]):return
	var l = load(Global.levels[id])
	if l != null:
		crt_lvl = id+1
		_hide([menu,game,ui],0.4)
		yield(get_tree().create_timer(0.5),"timeout")
		setup_player()
		on_game_bar.get_node("level").text = str(crt_lvl)
		set_to_visible([game,on_game_bar])
		_show([game,on_game_bar],0.5)
		game.add_child_below_node(game.get_child(0),l.instance())
		game.on_game = true
		if is_instance_valid(menu_show):menu_show.queue_free()
		lvls_l.queue_free()
	else:return

func setup_player():
	_player = player.instance()
	_player.mode = 1
	_player.applied_force = Vector2.ZERO
	_player.applied_torque = 0
	_player.position = player_initial_position
	_player.rotation_degrees = 0
	_player.mode = 0
	game.add_child(_player)

func lose():
	var ex = explosion.instance()
	ex.emitting = true
	ex.position = _player.position
	game.add_child(ex)
	if is_instance_valid(_player):_player.queue_free()
	Global.sub_boxs()
	set_to_visible([lose_l])
	_show([lose_l],0.2)
	Global._save()
	exit_level()


func win():
	set_to_visible([win_l])
	_show([win_l],0.2)
	exit_level()
	if crt_lvl == Global.o_lvl: p_lv_()

func exit_level():
	game.on_game = false
	yield(get_tree().create_timer(0.5),"timeout")
	Engine.time_scale = 1
	yield(get_tree().create_timer(0.4),"timeout")
	get_tree().change_scene_to(main)

func p_lv_():
	Global.p_lvl()
	Global._save()
	sync_boxs()


func sync_boxs():
	if is_instance_valid(boxs_l):boxs_l.text = str(Global.boxs)

func no_enough_boxs():
	b_anim.play("snaking")


func _on_watch_ads_pressed():
	_pb = pb.instance()
	set_to_visible(_pb.get_children())
	add_child(_pb)
	_show(_pb.get_children(),0.5)
	_pb.get_node("bar/anim").play("loop")
	Global.load_rewarded()

func close_pb():
	if is_instance_valid(_pb):
		_pb.queue_free()

func _on_back_pressed():
	_hide([game,on_game_bar],0.5)
	yield(get_tree().create_timer(0.5),"timeout")
	exit_level()

#-------------------------------------------------------------

func hide_node(nodes):
	for n in nodes:
		n.hide()
		n.modulate = Color.transparent

func set_to_visible(nodes):
	for n in nodes:
		n.show()
		n.modulate = Color.transparent
func _show(nodes,duration):
	set_to_visible(nodes)
	for n in nodes:
		tween.interpolate_property(n,"modulate",null,Color.white,duration)
	if nodes!= null:tween.start()
func _hide(nodes,duration):
	for n in nodes:
		tween.interpolate_property(n,"modulate",null,Color.transparent,duration)
	if nodes!= null:tween.start()
	yield(tween,"tween_all_completed")
	hide_node(nodes)
func _enter_tree():
	Global.main = self


