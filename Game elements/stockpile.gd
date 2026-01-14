class_name Stockpile
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element class
# var cards_stack : Array[Card] = [] Defined in Table_Element class
# var current_index: int = 0 Defined in Table_Element class
#@onready var open_pos: Vector2 =Vector2(100,0) #TODO: make this not hardcoded?
@onready var click_closed: Area2D = $Click_Closed
@onready var click_opened: Area2D = $Opened/Click_Opened # TODO: might not need, use card hitbox instead!
var open_offset = Vector2(50,0)
var step = 3 # TODO: maybe make this non-hardcoded?

func initiate(cards : Array[Card]) -> void:
	current_index=-1 # No cards open currently
	if not cards.is_empty():
		cards_stack=cards
		num_cards=len(cards)
		for card in cards_stack:
			card.reparent(self)
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",Vector2(0,0),1)
			card.current_position=position

func _on_click_closed_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		print("Revealing stock yay")
		var new_index: int
		if current_index<num_cards-3:# num_card-> last_index+1
			new_index=current_index+3
		else:
			new_index=num_cards-1
		print("Test 1")
		#TODO: insert func to make all currently open cards fall in line
		var revealed: Array[Card] = cards_stack.slice(current_index+1,new_index+1)
		var shift = Vector2(0,0)
		print("Test 2 ",revealed)
		print(current_index,new_index)
		#TODO: Make sure topmost element in array->bottom most in opened
		for card in revealed:
			print("bruh")
			card.reparent(click_opened) #TODO: might be messy beware
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",shift,0.5)
			shift+=open_offset
			card.move_to_front()
			card.flip_card()
			card.disable()
		current_index=new_index
