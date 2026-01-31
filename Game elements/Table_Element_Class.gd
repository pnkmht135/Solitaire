class_name Table_Element
extends Node2D

@onready var num_cards : int = 0
@onready var cards_stack : Array[Card] = []
@onready var current_index: int = 0 

func _ready() -> void:
	set_process(false)

func initiate(cards : Array[Card]) -> void:
	pass

func add_card(card:Card)->void:
	pass
	
func remove_card(card:Card)->void:
	pass

func can_add_card(card:Card)->bool:
	return false
