class_name Tableau
extends Node2D

@onready var num_cards : int = 0
@onready var cards_stack : Array[Card] = []
@onready var sprite_2d: Sprite2D = $Sprite2D
# TODO: look into whether godot append puts at front or end
#TODO: add the hitbox for selecting and droping cards
@onready var offset : int = 10
# Called when the node enters the scene tree for the first time.
func initiate() -> void:
	# render stack if exists, set hitboxes and card hiddenness accodingly accordingly.
	if not cards_stack.is_empty():
		var current_offset= 0
		for card in cards_stack:
			# TODO: enable Y sorting or somthing so overlap correctly
			# TODO: perhaps tweening?
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(card,"position",position+Vector2(0,current_offset),1)
			#card.position=self.position+Vector2(0,current_offset)
			current_offset+=offset
			card.move_to_front()
			add_child(card)
			print(card.num)
			print(self.name)
			print(card.visible)
			print(card.hidden)
		cards_stack[-1].flip_card() #TODO change to correct idk
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
