class_name Card
extends Node2D

@onready var sprite: Sprite2D = %sprite
@onready var sprite_dict: Dictionary = Global.sprite_dict
#@onready var parent: Node2D = null # is it in the stockpile or tableau or a pile
@onready var in_hand: bool = false 
@onready var current_position: Vector2 = Vector2(0,0)
@export var suit : Global.Suit = Global.Suit.HIDDEN
@export_range(0,12) var num : int = 1
@export var is_hidden : bool = true

# TODO: add card hitbod that is disabled by default, enabled when in hand.
# TODO: have the index of the card in its parent saved in card itself.
func flip_card()->void:
	# Change cards suit and num for consistancys
	var new_frame=Vector2i(num,suit)
	if not(is_hidden):
		new_frame=Vector2i(sprite_dict["hidden_column"],sprite_dict[Global.Suit.HIDDEN])
		is_hidden=true
	else:
		is_hidden=false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "scale:x", 0, 0.5)
	tween.tween_property(sprite, "frame_coords", new_frame,0)
	tween.tween_property(sprite, "scale:x", 1,0.5)
	

# TODO: make more efficient so that process only active when in hand, use set_process(false)
func _process(delta: float) -> void:
	if in_hand:
		global_position=get_global_mouse_position()
		if Input.is_action_just_released("Click"):
			#print("Dropped card")
			var tween_drop = create_tween()
			tween_drop.set_ease(Tween.EASE_IN_OUT)
			#print("Sending back")
			tween_drop.tween_property($".","global_position",current_position,0.5)
			#print("Back")
			in_hand=false
			#await in_hand==false
			set_process(false)
			
