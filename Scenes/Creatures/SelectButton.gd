extends Button


func _make_custom_tooltip(for_text):
	var label = RichTextLabel.new()
	label.custom_minimum_size = Vector2(300,0)
	label.fit_content = true
	label.set_use_bbcode(true)
	label.text = for_text
	return label
