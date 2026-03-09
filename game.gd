class_name  Game
extends Node2D

@export var CARD: PackedScene
# TODO: change these to be @export instaed?
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

var Tablueas : Array[Tableau]
var Foundation_Piles : Array[Foundation_Pile]
var Deck : Array[Card]

func _ready() -> void:
	# Generate deck of cards
	var suits: Array[Global.Suit] =[Global.Suit.HEART,Global.Suit.DIAMOND,Global.Suit.SPADE,Global.Suit.CLOVER]
	Foundation_Piles=[heart_pile,spade_pile,diamond_pile,clover_pile]
	Tablueas=[
		tableau_1,
		tableau_2,
		tableau_3,
		tableau_4,
		tableau_5,
		tableau_6,
		tableau_7
	]
	for suit in suits:
		for i in range(0,13):
			var card = CARD.instantiate()
			card.suit = suit
			card.foundation_pile=Foundation_Piles[suit]
			card.num = i
			card.game = self
			Deck.append(card)
			add_child(card)
	#Deck.shuffle()
	# Distribute the shuffled deck among table elements
	var index = 0
	var counter = 1
	for tableau in Tablueas:
		tableau.initiate(Deck.slice(index,index+counter))
		index+=counter
		counter+=1
	stockpile.initiate(Deck.slice(index,53))
		
func are_Foundation_Piles_Full()->bool:
	for pile in Foundation_Piles:
		if pile.num_cards!=13:
			return false
	return true

func check_game_win():
	if are_Foundation_Piles_Full():
		print("Party!!")
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		for pile in Foundation_Piles:
			pile.cards_stack.reverse()
			tween.tween_callback(pile.move_to_front)
			for card in pile.cards_stack:
				card.z_index = 10
				card.party(tween,100)
