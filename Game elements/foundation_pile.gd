class_name Foundation_Pile
extends Table_Element

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var suit: Global.Suit= Global.Suit.HEART
@export var game : Game
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
	if num_cards == 13:
		game.check_game_win()
	
func remove_card(card:Card, index:int)->void:
	if not(cards_stack.is_empty()) and card!=cards_stack[-1]:
		push_error("Can only remove topmost card from ",self.name)
		return
	cards_stack.erase(card)
	num_cards-=1
	if not cards_stack.is_empty():
		cards_stack[-1].enable()

func can_add_card(card:Card)->bool:
	if card.suit == suit and card.num == num_cards:
		return true
	return false
