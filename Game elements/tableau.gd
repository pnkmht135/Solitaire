class_name Tableau
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element Class
# var cards_stack : Array[Card] = [] Defined in Table_Elemet Class
# var current_index: int = 0 Defined in Table_Element class
# Here current_index is the index of the first open card
@onready var area: Area2D = $Area
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
		#print(self.name,num_cards)
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
		area.position+=Vector2(0,current_offset-offset)
		area.move_to_front()
		cards_stack[-1].flip_card() 

func _process(_delta: float) -> void:
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
				card_to_add.move_to(self)
				return
			#print("Cant place here ",card_to_add.current_position," ",card_to_add.parent)
			card_to_add.return_to_place()
			set_process(false)

#TODO: bug when you contiuously move a card between 2 tablueas:
# Area keeps moving upwards i think num_cards mauy also be affected.

func add_card(card: Card):
	#TODO: properly handle cases of adding stack of crads for moving area
	#TODO: handle open card spacing when moving area
	card.in_hand=false
	#card.reparent(self)
	#card.position=Vector2(0,offset*num_cards)
	print(card.num," adding, stack has ",num_cards)
	if num_cards>0:
		print("adding to a non-empty stack")
		var topcard= cards_stack[-1]
		area.position=Vector2(0,offset*num_cards)
		topcard.make_clickbox_stacksized()
		card.reparent(topcard)
		#card.parent=self
		#card.parent=topcard #TODO: whoops, how do I do this? Or better not to do it...
		card.position=Vector2(0,offset)
		card.current_position=card.position
	elif num_cards==0:
		print("Empty stack!!")
		card.reparent(self)
		card.position=Vector2(0,0)
		card.current_position=card.position
	num_cards+=len(card.get_children().filter(func(n):return n is Card))+1
	cards_stack.append(card)
	for child in card.get_children().filter(func(n):return n is Card):
		cards_stack.append(child)

func remove_card(card:Card,index:int)->void:
	#TODO: Bug where tabluea area being sent too high/back
	if cards_stack.is_empty():
		push_error("Cannot remove card from an empty Tabluea: ",self.name)
		return
	#if card!=cards_stack[-1]:
		## TODO:this is confusing me, not pushing or printing error??
		#print("Can only remove card from the end of Tabluea")
		#push_error("Can only remove card from the end of Tabluea for now.")
	var remove_stack=card.get_children().filter(func(n):return n is Card)
	print(len(remove_stack)," number of children")
	cards_stack.erase(card)
	num_cards-=1
	for child in remove_stack:
		cards_stack.erase(card)
		num_cards-=1		
	if num_cards<0:
		num_cards=0
		area.position=Vector2(0,0)
	else:
		area.position=Vector2(0,offset*(num_cards-1)) #TODO: -1 or not?
	if not(cards_stack.is_empty()):
		var topcard = cards_stack[-1]
		print(topcard.num," Is revealed? ",topcard.is_hidden) #TODO:sometimes not flipped whn should
		if topcard.is_hidden:
			#TODO: sometimes not being called
			print("Card revealed.")
			cards_stack[-1].flip_card()
			return
		topcard.reset_clickbox()
# TODO: change func names to reflect click area rename to area
func _on_click_area_area_entered(card_area: Area2D) -> void:
	# when a card hitbox enteres tablue click area
	if self.is_ancestor_of(card_area) or (card_to_add!=null and card_to_add.is_ancestor_of(card_area)):
		# No interaction if card is already part of the tabluea
		return
	card_to_add = card_area.get_parent()
	set_process(true)

func _on_click_area_area_exited(_card_area: Area2D) -> void:
	# might need if statement
	card_to_add = null
	set_process(false)
	
