extends Control

@onready var audio_player = $Typing
var current_segment = 0
var segments = [
	{ "start": 0.0, "end": 9.5 },
	{ "start": 9.88, "end": 19.15 },
	{ "start": 21.0, "end": 30.28 },
	{ "start": 31.05, "end": 40.33 },
	{ "start": 41.66, "end": 50.96 },
	{ "start": 51.73, "end": 61.0 },
]

func _ready():
	play_current_segment()

func play_current_segment():
	if current_segment >= segments.size():
		current_segment = 0
	
	var segment = segments[current_segment]
	if audio_player.playing:
		audio_player.seek(segment.start)
	else:
		audio_player.play()
		audio_player.seek(segment.start)
	
	audio_player.volume_db = -10
	var duration = segment.end - segment.start
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(_on_segment_timer_timeout.bind(timer))
	timer.start()

func _on_segment_timer_timeout(timer):
	audio_player.volume_db = -80
	timer.queue_free()
	current_segment += 1
	
	var next_segment_timer = Timer.new()
	add_child(next_segment_timer)
	next_segment_timer.wait_time = segments[current_segment % segments.size()].start - segments[(current_segment - 1) % segments.size()].end
	next_segment_timer.one_shot = true
	next_segment_timer.timeout.connect(_on_next_segment_start.bind(next_segment_timer))
	next_segment_timer.start()

func _on_next_segment_start(timer):
	timer.queue_free()
	audio_player.volume_db = 0
	play_current_segment()

func start_playback():
	current_segment = 0
	play_current_segment()

func stop_playback():
	audio_player.stop()
	for child in get_children():
		if child is Timer:
			child.queue_free()

func pause_playback():
	audio_player.stream_paused = true

func resume_playback():
	audio_player.stream_paused = false
