extends Label

func _ready():
	Global.timer = self
	text = to_dig(Global.time)

func _process(delta):
	if Global._t:
		Global.time -= delta
		#var mils = fmod(time,1)*1000
		sync_time()
		if Global.time <=0:
			Global.time_out()


func to_dig(s):
	var secs = fmod(s,60)
	var mins = fmod(s, 60*60) / 60
	#var hr = fmod(fmod(time,3600 * 60) / 3600,24)
	#var dy = fmod(time,12960000) / 86400
		
	var time_passed = "%02d : %02d" % [mins,secs]
	return time_passed

func sync_time():
	text = to_dig(Global.time)
