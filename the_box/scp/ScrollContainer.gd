extends ScrollContainer

#Modes list script .............................

export(float, 0.5, 1, 0.1) var card_scale = 1.0
export(float, 0.5, 1.5, 0.1) var card_current_scale = 0.8
export(float, 0.1, 1, 0.1) var scroll_duration = 1.3
export var _main:NodePath

var card_current_index: int = 0
var card_x_positions: Array = []
var act_btns:Array = []

onready var s_lvls:Node = $CenterContainer/MarginContainer/HBoxContainer
onready var scroll_tween: Tween = Tween.new()
onready var margin_r: int = $CenterContainer/MarginContainer.get("custom_constants/margin_right")
onready var card_space: int = $CenterContainer/MarginContainer/HBoxContainer.get("custom_constants/separation")
onready var card_nodes: Array = $CenterContainer/MarginContainer/HBoxContainer.get_children()
onready var main = get_node(_main)

func _enter_tree():
	sync_lvls()

func _ready() -> void:
	add_child(scroll_tween)
	yield(get_tree(), "idle_frame")
	#Wait all nodes to be _ready
	main.set_color()
	card_current_index = Global.o_lvl-1
	set_act_btn()
	get_h_scrollbar().modulate.a = 0
	for _card in card_nodes:
		var _card_pos_x: float = (margin_r + _card.rect_position.x) - ((rect_size.x - _card.rect_size.x) / 2)
		_card.rect_pivot_offset = (_card.rect_size / 2)
		card_x_positions.append(_card_pos_x)
		
	scroll_horizontal = card_x_positions[card_current_index]
	scroll()


func _process(_delta: float) -> void:
	for _index in range(card_x_positions.size()):
		var _card_pos_x: float = card_x_positions[_index]
		var _swipe_length: float = (card_nodes[_index].rect_size.x / 2) + (card_space / 2)
		var _swipe_current_length: float = abs(_card_pos_x - scroll_horizontal)
		var _card_scale: float = range_lerp(_swipe_current_length, _swipe_length, 0, card_scale, card_current_scale)
		var _card_opacity: float = range_lerp(_swipe_current_length, _swipe_length, 0, 0.3, 1)
		
		_card_scale = clamp(_card_scale, card_scale, card_current_scale)
		_card_opacity = clamp(_card_opacity, 0.3, 1)
		
		card_nodes[_index].rect_scale = Vector2(_card_scale, _card_scale)
		card_nodes[_index].modulate.a = _card_opacity
		
		if _swipe_current_length < _swipe_length:
			if _index != card_current_index:
				card_current_index = _index
				set_act_btn()
				main.set_color()


func scroll() -> void:
	scroll_tween.interpolate_property(
		self,
		"scroll_horizontal",
		scroll_horizontal,
		card_x_positions[card_current_index],
		scroll_duration,
		Tween.TRANS_BACK,
		Tween.EASE_OUT)
	
	for _index in range(card_nodes.size()):
		var _card_scale: float = card_current_scale if _index == card_current_index else card_scale
		scroll_tween.interpolate_property(
			card_nodes[_index],
			"rect_scale",
			card_nodes[_index].rect_scale,
			Vector2(_card_scale,_card_scale),
			scroll_duration,
			Tween.TRANS_QUAD,
			Tween.EASE_OUT)
		
	scroll_tween.start()


func _on_ScrollContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			scroll_tween.stop_all()
		else:
			scroll()


func sync_lvls():
	var s = $CenterContainer/MarginContainer/HBoxContainer
	for c in s.get_children():
		c.queue_free()
	var t = load("res://res/thanks.res").instance()
	var lvl_btn = load("res://res/lvl_btn.res")
	var locked_lvl_btn = load("res://res/locked_lvl_btn.res")
	for l in range(Global.levels.size()):
		var b
		if l < Global.o_lvl:
			b = lvl_btn.instance()
			b.connect("pressed",self,"button_pressed")
		else:
			b = locked_lvl_btn.instance()
		b.get_node("l").text = str(l+1)
		s.add_child(b)
	if Global.o_lvl==Global.levels.size()+1:s.add_child(t)

func button_pressed():
	main.load_lvl(card_current_index)

func set_act_btn():
	for b in act_btns:
		b.disabled = true
	var btn = card_nodes[card_current_index]
	if btn is TextureButton:
		btn.disabled = false
		act_btns.append(btn)
	pass
