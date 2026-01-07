class_name Tableau
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element Class
# var cards_stack : Array[Card] = [] Defined in Table_Elemet Class
# var current_index: int = 0 Defined in Table_Element class
# Here current_index is the index of the first open card
@onready var click_area: Area2D = $Click_Area
# TODO: look into whether godot append puts at front or end
#TODO: add the hitbox for selecting and droping stack of cards
@onready var offset : int = 10
@onready var card_to_add : Card = null

func _ready() -> void:
	set_process(false)

func initiate(cards:Array[Card]) -> void:
	# render stack if exists, set hitboxes and card hiddenness accodingly accordingly.
	if not cards.is_empty():
		cards_stack=cards
		current_index=-1
		var current_offset= 0
		num_cards=len(cards_stack)
		for card in cards_stack:
			card.reparent(self)
			card.parent=self
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",Vector2(0,current_offset),1)
			card.current_position=Vector2(0,current_offset)
			current_offset+=offset
			card.move_to_front()
			#await tween.finished # dont like the look
		#await tween.finished # dont like the look
		click_area.position+=Vector2(0,current_offset-offset)
		click_area.move_to_front()
		cards_stack[-1].flip_card() 

func _process(delta: float) -> void:
	# TODO: manage this nesting!!!
	if card_to_add != null:
		if Input.is_action_just_released("Click"):
			if cards_stack.is_empty():
				if card_to_add.num==12:
					card_to_add.move_to(self)
				set_process(false)
				return
			var topcard=cards_stack[-1]
			if (topcard.suit)%2!=card_to_add.suit%2 and topcard.num-1==card_to_add.num:
				print(topcard.suit," ", card_to_add.suit, " Should be diff mod 2: ", topcard.suit%2," ", card_to_add.suit%2,Global.Suit.find_key(topcard.suit)," ",Global.Suit.find_key(card_to_add.suit))
				card_to_add.move_to(self)
				return
			card_to_add.return_to_place()
			set_process(false)

func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click"):
		if not cards_stack.is_empty():
			cards_stack[-1].current_position=self.position+Vector2(0,offset*(num_cards-1))
			cards_stack[-1].in_hand=true
			move_to_front()
			cards_stack[-1].set_process(true)

func add_card(card: Card):
	card.in_hand=false
	card.reparent(self)
	card.position=Vector2(0,offset*num_cards)
	if num_cards>0:
		click_area.position=Vector2(0,offset*num_cards)
	num_cards+=1
	cards_stack.append(card)

func remove_card(card:Card,index:int)->void:
	print("removing card?")
	if cards_stack.is_empty():
		push_error("Cannot remove card from an empty Tabluea: ",self.name)
		return
	if card!=cards_stack[-1]:
		push_error("Can only remove card from the end of Tabluea for now.")
	cards_stack.erase(card)
	num_cards-=1
	if num_cards>0:
		click_area.position-=Vector2(0,offset)
	else:
		num_cards=0
	if not(cards_stack.is_empty()) and cards_stack[-1].is_hidden:
		cards_stack[-1].flip_card()
	
func _on_click_area_area_entered(area: Area2D) -> void:
	# when a card hitbox enteres tablue click area
	if self.is_ancestor_of(area):
		# No interaction if card is already part of the tabluea
		return
	card_to_add = area.get_parent()
	set_process(true)

func _on_click_area_area_exited(area: Area2D) -> void:
	# might need if statement
	card_to_add = null
	set_process(false)
	
