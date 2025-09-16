extends RichTextEffect

class_name ShakeEffect

var bbcode = "shake"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t = Time.get_ticks_msec() / 1000.0
	var offset = sin(t * 30.0 + char_fx.relative_index * 0.5) * 2.0
	char_fx.offset = Vector2(offset, 0)
	return true
