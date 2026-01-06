extends Node2D

#const CARD = preload("res://Game elements/Card.tscn")
@export var CARD: PackedScene
@onready var tableau_1: Tableau = %Tableau1
@onready var tableau_2: Tableau = %Tableau2
@onready var tableau_3: Tableau = %Tableau3
@onready var tableau_4: Tableau = %Tableau4
@onready var tableau_5: Tableau = %Tableau5
@onready var tableau_6: Tableau = %Tableau6
@onready var tableau_7: Tableau = %Tableau7
var Deck : Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generate deck of cards
	var suits: Array[Global.Suit] =[Global.Suit.HEART,Global.Suit.DIAMOND,Global.Suit.SPADE,Global.Suit.CLOVER]
	for things in suits:
		for i in range(0,12):
			var card= CARD.instantiate()
			card.suit=things
			card.num=i
			Deck.append(card)
			add_child(card)
			
	# Shuffle!!
	Deck.shuffle()

	# Distribute the shuffled deck
	tableau_1.cards_stack=Deck.slice(0,1)
	tableau_1.initiate()
	tableau_2.cards_stack=Deck.slice(1,3)
	tableau_2.initiate()
	tableau_3.cards_stack=Deck.slice(3,7)
	tableau_3.initiate()
	tableau_4.cards_stack=Deck.slice(7,12)
	tableau_4.initiate()
	tableau_5.cards_stack=Deck.slice(12,18)
	tableau_5.initiate()
	tableau_6.cards_stack=Deck.slice(18,25)
	tableau_6.initiate()
	tableau_7.cards_stack=Deck.slice(25,33)
	tableau_7.initiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
