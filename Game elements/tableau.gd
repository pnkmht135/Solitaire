class_name Tableau
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element Class
# var cards_stack : Array[Card] = [] Defined in Table_Elemet Class
# var current_index: int = 0 Defined in Table_Element class
@onready var area: Area2D = $Area
@onready var offset : int = 10
@onready var card_to_add : Card = null
var first_open = 0

# TODO: do i need this to have a collision layer? Since clicking is handled in card
# BUG: long open stacks not handled properly so moving long stack-> next doesnt flip

# TODO: handle adding children to ALL open cards when adding carstack. 
# do this with current index to keep track of topmost open card.

func _ready() -> void:
	set_process(false)

func initiate(cards:Array[Card]) -> void:
	# render stack if exists, set hitboxes and card hiddenness accodingly accordingly.
	if not cards.is_empty():
		cards_stack=cards
		var current_offset= 0
		num_cards=len(cards_stack)
		first_open=num_cards-1
		var index:int=0
		for card in cards_stack:
# TODO: make cleaner buy using a function call?
			card.index=index
			card.reparent(self)
			card.parent=self
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",Vector2(0,current_offset),1)
			card.current_position=Vector2(0,current_offset)
			current_offset+=offset
			index+=1
			card.move_to_front()
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
				card_to_add = null
				set_process(false)
				return
			var topcard=cards_stack[-1]
			if (topcard.suit)%2!=card_to_add.suit%2 and topcard.num-1==card_to_add.num:
				card_to_add.move_to(self)
				card_to_add=null
				return
			#print("Cant place here ",card_to_add.current_position," ",card_to_add.parent)
			card_to_add.return_to_place()
			card_to_add=null
			set_process(false)

func add_card(card: Card):
	#TODO: properly handle cases of adding stack of crads for moving area
	#TODO: handle open card spacing when moving area
	if num_cards>0:
		#print("adding to a non-empty stack")
		var topcard= cards_stack[-1]
		topcard.make_clickbox_stacksized()
		card.reparent(topcard)
		card.index=num_cards
		print("before: %d has %d children" % [topcard.num,len(topcard.children)])
		topcard.children.append(card)
		topcard.children.append_array(card.children) # TODO: check if this works like python
		print("after: %d has %d children" % [topcard.num,len(topcard.children)])
		card.position=Vector2(0,offset)
		card.current_position=card.position
	elif num_cards==0:
		print("Empty stack!!")
		card.reparent(self)
		card.index=0
		card.position=Vector2(0,0)
		card.current_position=card.position
		#TODO: handle area.pos outside of if and elif?
	num_cards+=len(card.children)+1 # +1 to include card itself
	area.position=Vector2(0,offset*(num_cards))
	card.parent=self
	cards_stack.append(card)
	for child in card.children:
		cards_stack.append(child)
		child.parent=self
		

func remove_card(card:Card,index:int)->void:
	#TODO: Bug where tabluea area being sent too high/back
	#TODO: change to use first_open instead
	if cards_stack.is_empty():
		push_error("Cannot remove card from an empty Tabluea: ",self.name)
		return
	#print(len(remove_stack)," number of children")
	var card_children = cards_stack.slice(card.index+1,num_cards+1)
	cards_stack.erase(card)
	card.children=card_children
	num_cards-=1
	for child in card_children:
		cards_stack.erase(child) 
		print("removed: ",child.num)
		num_cards-=1		
	if num_cards<=0:
		num_cards=0
		area.position=Vector2(0,0)
	else:
		area.position=Vector2(0,offset*(num_cards-1)) 
	if not(cards_stack.is_empty()):
		var topcard = cards_stack[-1]  # is sometimes reading from the wrong card. Removal issue
		print(topcard.num," Is revealed? ",topcard.is_hidden) #TODO:sometimes not flipped whn should
		if topcard.is_hidden:
			print("Card revealed.")
			cards_stack[-1].flip_card()
			first_open=cards_stack[-1].index
			return
		# TODO: incorperate this loop into the prev children loop
		for child in card_children:
			topcard.children.erase(child)
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
	
