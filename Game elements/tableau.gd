class_name Tableau
extends Table_Element

# var num_cards : int = 0 Defined in Table_Element Class
# var cards_stack : Array[Card] = [] Defined in Table_Elemet Class
# var current_index: int = 0 Defined in Table_Element class
@onready var area: Area2D = $Area
var offset : int = 5
var open_offset: int = 10
@onready var card_to_add : Card = null
var first_open = 0

# TODO: do i need this to have a collision layer? Since clicking is handled in card
# BUG: long open stacks not handled properly so moving long stack-> next doesnt flip
# BUG: when arge stacks being moved around too seems like numcard/cardstack being reduced too much!!

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
			card.current_position=Vector2(0,current_offset)
			card.return_to_place(1)
			current_offset+=offset
			index+=1
			card.move_to_front()
		area.position+=Vector2(0,current_offset-offset)
		area.move_to_front()
		cards_stack[-1].flip_card() 

func can_add_card(card:Card)->bool:
	if cards_stack.is_empty():
		if card.num==12:
			return true
		return false
	var top_card = cards_stack[-1]
	if (top_card.suit)%2!=(card.suit)%2 and top_card.num-1==card.num:
		return true
	return false

func _process(_delta: float) -> void:
	if card_to_add != null:
		if Input.is_action_just_released("Click"):
			var can_add: bool = can_add_card(card_to_add)
			if can_add:
				card_to_add.move_to(self)
			card_to_add = null
			set_process(false)
	else:
		set_process(false) # for sanity

func get_offset()->int:
	#print("Stack info:",num_cards," ",first_open)	
	if num_cards==0:
		return 0
	return offset*first_open+(open_offset)*(num_cards-first_open-1)

# BUG: add card/remove card bug, seems like all children are not added to tabluea stack

func add_card(card: Card):
	if num_cards>0:
		#print("adding to a non-empty stack")
		var topcard= cards_stack[-1]
		topcard.make_clickbox_stacksized()
		card.reparent(topcard)
		card.index=num_cards
		#print("before: %d has %d children" % [topcard.num,len(topcard.children)])
		topcard.children.append(card)
		topcard.children.append_array(card.children) # TODO: check if this works like python
		#print("after: %d has %d children" % [topcard.num,len(topcard.children)])
		card.position=Vector2(0,open_offset)
		card.current_position=card.position
	elif num_cards==0:
		#print("Empty stack!!")
		card.reparent(self)
		card.index=0
		card.position=Vector2(0,0)
		card.current_position=card.position
		first_open=0
		#TODO: handle area.pos outside of if and elif?
	num_cards+=len(card.children)+1 # +1 to include card itself
	area.position=Vector2(0,get_offset())
	card.parent=self
	cards_stack.append(card)
	var index: int = card.index+1
	for child in card.children:
		cards_stack.append(child)
		child.index=index
		index+=1
		child.parent=self
		
# Change so card.children is no more and add_card takes in optional stack!
func remove_card(card:Card,index:int)->void:
	#TODO: Bug removing sends hitbox to 0 and doesnt reset card box
	if cards_stack.is_empty():
		push_error("Cannot remove card from an empty Tabluea: ",self.name)
		return
	var card_children = cards_stack.slice(card.index+1,num_cards+1)
	cards_stack.erase(card)
	card.children=card_children
	num_cards-=1
	for child in card_children:
		cards_stack.erase(child) 
		#print("removed: ",child.num)
		num_cards-=1		
	if not(cards_stack.is_empty()):
		var topcard = cards_stack[-1]  
		#print(topcard.num," Is revealed? ",topcard.is_hidden) 
		if topcard.is_hidden:
			#print("Card revealed. ",topcard.index)
			topcard.flip_card()
			first_open=topcard.index
		topcard.reset_clickbox()
	else:
		first_open=-1
	area.position=Vector2(0,get_offset()) #calling too early, b4 firstopen is set

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
	
