class_name Card
extends Node2D

@onready var sprite: Sprite2D = %sprite
@onready var sprite_dict: Dictionary = Global.sprite_dict
@onready var parent: Table_Element = null # is it in the stockpile or tableau or a pile
@onready var index: int = 0
@onready var in_hand: bool = false 
@onready var current_position: Vector2
@export var suit : Global.Suit = Global.Suit.HIDDEN
@export_range(0,12) var num : int = 1
@export var is_hidden : bool = true
# TODO: let non-hidden cards in a Tabluea have children.
# TODO: add card hitbod that is disabled by default, enabled when in hand.
# TODO: have the index of the card in its parent saved in card itself.
func _ready() -> void:
	set_process(false)

func flip_card()->void:
	# Change cards suit and num for consistancys
	var new_frame=Vector2i(num,sprite_dict.find_key(suit))
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
	
func move_to(new_parent:Table_Element)->void:
	if parent:
		parent.remove_card(self,index) 
	new_parent.add_card(self)
	#reparent(new_parent) 
	parent=new_parent

func return_to_place()->void:
	if not(current_position):
		push_error("Tried to return a card without a set current place")
		return
	var tween_drop = create_tween()
	tween_drop.set_ease(Tween.EASE_IN_OUT)
	#TODO: double check if global or local needed here 
	tween_drop.tween_property($".","global_position",current_position,0.5)
	

func _process(delta: float) -> void:
	if in_hand: # TODO: fix buc where Drop card logic overrides addcard logic.
		global_position=get_global_mouse_position()
		if Input.is_action_just_released("Click"):
			# TODO: Make this if statement cleaner
			if not($Hit_Box.has_overlapping_areas()) or $Hit_Box.overlaps_area(parent.get_node_or_null("Click_Area")):
				return_to_place()
			in_hand=false
			set_process(false)
			
