class_name  Game
extends Node2D

@export var CARD: PackedScene
# TODO: change these to be @export instaed.
@onready var tableau_1: Tableau = %Tableau1
@onready var tableau_2: Tableau = %Tableau2
@onready var tableau_3: Tableau = %Tableau3
@onready var tableau_4: Tableau = %Tableau4
@onready var tableau_5: Tableau = %Tableau5
@onready var tableau_6: Tableau = %Tableau6
@onready var tableau_7: Tableau = %Tableau7
@onready var stockpile: Stockpile = $Stockpile
@onready var heart_pile: Foundation_Pile = $Heart_Pile
@onready var diamond_pile: Foundation_Pile = $Diamond_Pile
@onready var spade_pile: Foundation_Pile = $Spade_Pile
@onready var clover_pile: Foundation_Pile = $Clover_Pile

var Foundation_Piles: Array[Foundation_Pile]
# for some raason declaring this array and its contents here is not working, this init in _ready()

var Deck : Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generate deck of cards
	# TODO: lookinto this ysort stuff:
	#y_sort_enabled=true
	var suits: Array[Global.Suit] =[Global.Suit.HEART,Global.Suit.DIAMOND,Global.Suit.SPADE,Global.Suit.CLOVER]
	print(suits)
	Foundation_Piles=[heart_pile,spade_pile,diamond_pile,clover_pile]
	for suit in suits:
		for i in range(0,13):
			var card= CARD.instantiate()
			card.suit=suit
			card.foundation_pile=Foundation_Piles[suit]
			card.num=i
			Deck.append(card)
			add_child(card) # can comment this out to have cards start in tableuas/other
	Deck.shuffle()
	# Distribute the shuffled deck among game elements
	tableau_1.initiate(Deck.slice(0,1))
	tableau_2.initiate(Deck.slice(1,3))
	tableau_3.initiate(Deck.slice(3,6))
	tableau_4.initiate(Deck.slice(6,10))
	tableau_5.initiate(Deck.slice(10,15))
	tableau_6.initiate(Deck.slice(15,21))
	tableau_7.initiate(Deck.slice(21,28))
	stockpile.initiate(Deck.slice(28,53))
		
func are_Foundation_Piles_Full()->bool:
	for pile in Foundation_Piles:
		if pile.num_cards!=13:
			return false
	return true

func check_game_win():
	if are_Foundation_Piles_Full():
		print("Party!!")
		for card in Deck:
			card.party()
