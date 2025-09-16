extends RichTextEffect
class_name WavyEffect

var bbcode = "wavy"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t = Time.get_ticks_msec() / 1000.0
	var wave = sin(t * 5.0 + char_fx.relative_index * 0.5) * 5.0
	char_fx.offset = Vector2(0, wave)
	return true
