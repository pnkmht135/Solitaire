class_name Stockpile
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element class
# var cards_stack : Array[Card] = [] Defined in Table_Element class
# var current_index: int = 0 Defined in Table_Element class
#@onready var open_pos: Vector2 =Vector2(100,0) #TODO: make this not hardcoded?
@onready var click_closed: Area2D = $Click_Closed
@onready var click_opened: Area2D = $Opened/Click_Opened # TODO: might not need, use card hitbox instead!
var open_offset = Vector2(15,0)
var step = 3 # TODO: maybe make this non-hardcoded?

func initiate(cards : Array[Card]) -> void:
	current_index=-1 # No cards open currently
	if not cards.is_empty():
		cards_stack=cards
		num_cards=len(cards)
		#var ip = Vector2(0,0)
		for card in cards_stack:
			card.reparent(self)
			card.parent=self
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",Vector2(0,0),1)
			#ip+=Vector2(10,0)
			card.current_position=position
		cards_stack.reverse() # because it is facedown on table.
		click_opened.move_to_front()

func _on_click_closed_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		# Do nothing if no cards
		if cards_stack.is_empty():
			return
		if current_index!=-1: # If there are already open cards:
			# Disable latest open card
			cards_stack[current_index].disable() # TODO: moove opened cards back to 0,0!
			# Move them to (0,0)
			for card in cards_stack.slice(max(0,current_index-2),current_index+1):
				var tween = create_tween()
				tween.set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(card,"position",Vector2(0,0),0.5)
			
		# for card "in open": card.position = vec2(0,0) 
		# like if current_index != -1 slice  
		# Reset stockpile if at end
		if current_index == num_cards-1:
			for card in cards_stack:
				card.reparent(self)
				var tween=create_tween()
				tween.set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(card,"position",Vector2(0,0),0.5)
				card.flip_card()
			current_index=-1
			return
		var new_index: int
		# Typical case: reveal next 3 closed cards
		if current_index<num_cards-3:# num_card-> last_index+1
			new_index=current_index+3
		# Edge case: less than 3 remaining to reveal -> reveal remaining
		else:
			new_index=num_cards-1
		#TODO: insert func to make all currently open cards fall in line
		var revealed: Array[Card] = cards_stack.slice(current_index+1,new_index+1)
		#revealed.reverse() # Ensure topmost closed element -> bottommost opened
		var shift = Vector2(0,0)
		#TODO: Make sure topmost element in array->bottom most in opened
		for card in revealed:
			card.reparent(click_opened) #TODO: might be messy beware		
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",shift,1)
			card.current_position=shift
# TODO: tween before reparenting so that doesnt swtich to rendering bellow other cards.
# TODO: that did not fix it, still redering in back when tween starts, what is tween doing.
			shift+=open_offset
			card.flip_card() # comment out for testing things
			card.disable()
		current_index=new_index
		revealed[-1].enable()
