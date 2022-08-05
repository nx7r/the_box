extends Node


var SAVEPATH = "user://cash.enc"
var game : Node
var player : Node
var bg : Node
var camera : Node
var main : Node
var boxs : int = 3
var o_lvl : int = 1
var wait_time : float = 90
var _t = false
var timer : Node
var levels:PoolStringArray = [
	"res://levels/1.res",
	"res://levels/2.res",
	"res://levels/3.res",
	"res://levels/4.res",
	"res://levels/5.res",
	"res://levels/6.res",
	"res://levels/7.res",
	"res://levels/8.res",
	"res://levels/9.res",
	"res://levels/10.res",
	"res://levels/11.res",
	"res://levels/12.res",
	]

onready var time : float = wait_time

func _enter_tree():
	_load()

func _ready():
	MobileAds.connect("banner_loaded",self,"banner_loaded")
	MobileAds.connect("rewarded_ad_loaded",self,"rewarded_loaded")
	MobileAds.connect("user_earned_rewarded",self,"rewarded_earned")
	MobileAds.connect("rewarded_ad_failed_to_load",self,"ad_faild")
	MobileAds.connect("rewarded_ad_failed_to_show",self,"ad_faild")
	MobileAds.connect("rewarded_ad_closed",self,"hide_pb")
	s_t()

func s_t():
	if boxs < 3:
		_t = true
		if time <=0: time = wait_time
	else:
		time = 0
		_t = false
	_save()
	if is_instance_valid(main): main.sync_boxs()
	if is_instance_valid(timer): timer.sync_time()
	

func sub_boxs():
	if boxs > 0:boxs-=1
	s_t()

func time_out():
	if boxs < 3:
		boxs+=1
	if boxs >= 3:
		_t = false
		time = 0
	s_t()

func _save():
	var savefile = File.new()
	savefile.open(SAVEPATH,File.WRITE)
	var data = {
		'boxs':boxs,
		'lvl':o_lvl
		}
	savefile.store_var(data)
	savefile.close()

func _load():
	var savefile = File.new()
	if savefile.file_exists(SAVEPATH):
		savefile.open(SAVEPATH,File.READ)
		var data = savefile.get_var()
		if typeof(data) == TYPE_DICTIONARY:
			if typeof(data['boxs']) == TYPE_INT:boxs = data['boxs']
			if typeof(data['lvl']) == TYPE_INT:o_lvl = data['lvl']
	if o_lvl > levels.size():o_lvl = levels.size()+1

func p_lvl():
	var _o = o_lvl
	o_lvl += 1
	if o_lvl > levels.size():o_lvl = levels.size()+1

func load_banner():
	MobileAds.load_banner()

func banner_loaded():
	MobileAds.show_banner()

func load_rewarded():
	MobileAds.load_rewarded()

func rewarded_loaded():
	MobileAds.show_rewarded()

func rewarded_earned(_currency, _amount):
	main.close_pb()
	boxs += 1
	s_t()

func ad_faild(_err):
	hide_pb()

func hide_pb():
	main.close_pb()
	
