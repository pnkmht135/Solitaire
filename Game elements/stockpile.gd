class_name Stockpile
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element class
# var cards_stack : Array[Card] = [] Defined in Table_Element class
# var current_index: int = 0 Defined in Table_Element class
@onready var click_closed: Area2D = $Click_Closed
@onready var opened_cards = $Opened_cards_area
var open_offset = Vector2(15,0)
@export var step = 3 # TODO: maybe make this non-hardcoded? 

func initiate(cards : Array[Card]) -> void:
	current_index=-1 # No cards open initially
	if not cards.is_empty():
		cards_stack=cards
		num_cards=len(cards)
		for card in cards_stack:
			card.reparent(self)
			card.parent=self
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",Vector2(0,0),1)
			card.current_position=position
		cards_stack.reverse() # because it is facedown on table.
		opened_cards.move_to_front()

func remove_card(card:Card)->void:
	if current_index==-1:
		push_error("Cannot remove from a closed/empty stockpile.")
		return
	if card!=cards_stack[current_index]:
		push_error("You can only remove the topmost open card from the stockpile.")
		return
	# Remove card in question
	cards_stack.erase(card)
	current_index-=1
	num_cards-=1
	# Enable the next topmost open card
	if current_index>-1:
		cards_stack[current_index].enable()

func _on_click_closed_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		# Do nothing if no cards
		if cards_stack.is_empty():
			return
		click_closed.input_pickable = false
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_parallel()
		# Hanlding already open cards if needed:
		if current_index!=-1:
			cards_stack[current_index].disable() # Disable latest open card
			for open_card in cards_stack.slice(max(0,current_index-(step-1)),current_index+1):
				open_card.current_position=Vector2(0,0)
				tween.tween_property(open_card,"position",Vector2(0,0),0.5)
		# Case where all cards are open
		if current_index == num_cards-1:
			for card in cards_stack:
				card.reparent(self)
				tween.tween_property(card,"position",Vector2(0,0),0.5)
				card.flip_card()
			current_index=-1
			await tween.finished
			click_closed.input_pickable = true
			return
		var new_index: int
		opened_cards.move_to_front()
		# Typical case, reveal next 3 closed cards
		if current_index<num_cards-step: # num_card -> last_index+1
			new_index=current_index+step
		# Edge case, less than 3 remaining to reveal -> reveal remaining
		else:
			new_index=num_cards-1
		var revealed: Array[Card] = cards_stack.slice(current_index+1,new_index+1)
		var shift = Vector2(0,0)
		for card in revealed:
			card.reparent(opened_cards)
			tween.tween_callback(card.move_to_front)
			tween.tween_property(card,"position",shift,1)
			card.current_position=shift
			shift+=open_offset
			card.flip_card()
			card.disable()
		current_index=new_index
		await tween.finished
		click_closed.input_pickable = true
		revealed[-1].enable()
