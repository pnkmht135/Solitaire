class_name Stockpile
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element class
# var cards_stack : Array[Card] = [] Defined in Table_Element class
# var current_index: int = 0 Defined in Table_Element class

# Called when the node enters the scene tree for the first time.
func initiate(cards : Array[Card]) -> void:
	if not cards.is_empty():
		cards_stack=cards
		for card in cards_stack:
			card.reparent(self)
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",Vector2(0,0),1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
