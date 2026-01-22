class_name  Game
extends Node2D

@export var CARD: PackedScene
@onready var tableau_1: Tableau = %Tableau1
@onready var tableau_2: Tableau = %Tableau2
@onready var tableau_3: Tableau = %Tableau3
@onready var tableau_4: Tableau = %Tableau4
@onready var tableau_5: Tableau = %Tableau5
@onready var tableau_6: Tableau = %Tableau6
@onready var tableau_7: Tableau = %Tableau7
@onready var stockpile: Stockpile = $Stockpile
var Foundation_Piles: Array[Foundation_Pile] = [
	$Heart_Pile,
	$Diamond_Pile,
	$Spade_Pile,
	$Clover_Pile
]

var Deck : Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generate deck of cards
	# TODO: lookinto this ysort stuff:
	#y_sort_enabled=true
	var suits: Array[Global.Suit] =[Global.Suit.HEART,Global.Suit.DIAMOND,Global.Suit.SPADE,Global.Suit.CLOVER]
	for things in suits:
		for i in range(0,13):
			var card= CARD.instantiate()
			card.suit=things
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
	return Foundation_Piles.all(func(value): return value==13)

func check_game_win():
	if are_Foundation_Piles_Full():
		print("Party!!")
		for card in Deck:
			card.party()
