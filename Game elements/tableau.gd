class_name Tableau
extends Node2D

@onready var num_cards : int = 0
@onready var cards_stack : Array[Card] = []
@onready var click_area: Area2D = $Click_Area
# TODO: look into whether godot append puts at front or end
#TODO: add the hitbox for selecting and droping cards
@onready var offset : int = 10
# Called when the node enters the scene tree for the first time.
func initiate() -> void:
	# render stack if exists, set hitboxes and card hiddenness accodingly accordingly.
	if not cards_stack.is_empty():
		var current_offset= 0
		num_cards=len(cards_stack)
		#var tween = create_tween()
		for card in cards_stack:
			card.reparent(self) 
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			#tween.tween_property(card,"position",position+Vector2(0,current_offset),1)
			tween.tween_property(card,"position",Vector2(0,current_offset),1)
			#card.position=self.position+Vector2(0,current_offset)
			current_offset+=offset
			card.move_to_front()
			#print(card.get_parent().name)
			#await tween.finished # dont like the look
		#await tween.finished # dont like the look
		click_area.position+=Vector2(0,current_offset-offset)
		click_area.move_to_front()
		cards_stack[-1].flip_card() 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_click_area_mouse_entered() -> void:
	#print("hovering ",self.name)
#
#
#func _on_click_area_mouse_exited() -> void:
	#print("left ",self.name)


func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("Click"):
		if not cards_stack.is_empty():
			cards_stack[-1].current_position=position+Vector2(0,offset*(num_cards-1))
			cards_stack[-1].in_hand=true
