class_name Foundation_Pile
extends Table_Element

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var suit: Global.Suit= Global.Suit.HEART
var card_to_add: Card = null
# var num_cards : int = 0 Defined in Table_Element Class
# var cards_stack : Array[Card] = [] Defined in Table_Elemet Class

# Called when the node enters the scene tree for the first time.
# TODO: do i need this to have a collision layer? Since clicking is handled in card
func _ready() -> void:
	var map={
		Global.Suit.HEART:54,
		Global.Suit.DIAMOND:55,
		Global.Suit.SPADE:56,
		Global.Suit.CLOVER:57,
	}
	sprite_2d.frame=map[suit]

func add_card(card:Card)->void:
	if not cards_stack.is_empty():
		var topcard: Card = cards_stack[-1]
		topcard.disable()
	card.reparent(self)
	card.parent=self 
	card.position=Vector2(0,0)
	card.current_position=Vector2(0,0)
	cards_stack.append(card)
	card.enable()
	num_cards+=1
	
func remove_card(card:Card, index:int)->void:
	if card!=cards_stack[-1]:
		push_error("Can only remove topmost card from ",self.name)
		return
	cards_stack.erase(card)
	num_cards-=1
	cards_stack[-1].enable()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_to_add != null:
		if Input.is_action_just_released("Click"):
			print("Trying to add card num %d suit %d to pile %d" % [card_to_add.num,card_to_add.suit,suit])
			print(card_to_add)
			if card_to_add.suit == suit and card_to_add.num == num_cards:
				print("Added to foundation pile %d!" % suit)
				print(card_to_add) # not null
				card_to_add.move_to(self)	#TODO: why is this makeing null
				print(card_to_add) # is null now???
				card_to_add = null
				set_process(false)
				return
				#card_to_add.return_to_place()
			#else:
			card_to_add.return_to_place()
			card_to_add = null
			set_process(false)

func _on_area_area_entered(card_area: Area2D) -> void:
	# when a card hitbox enteres tablue click area
	if self.is_ancestor_of(card_area) or (card_to_add!=null and card_to_add.is_ancestor_of(card_area)):
		# No interaction if card is already in the pile
		return
	card_to_add = card_area.get_parent()
	set_process(true)


func _on_area_area_exited(area: Area2D) -> void:
	# might need if statement
	card_to_add = null
	set_process(false)
