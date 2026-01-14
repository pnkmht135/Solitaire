class_name Card
extends Node2D

# Note: card Clickbox disabled on default.
@onready var sprite: Sprite2D = %sprite
@onready var sprite_dict: Dictionary = Global.sprite_dict
@onready var parent: Table_Element = null # is it in the stockpile or tableau or a pile
@onready var index: int = 0
@onready var in_hand: bool = false 
@onready var current_position: Vector2 = Vector2(0,0)
var suit : Global.Suit = Global.Suit.HIDDEN
@export_range(0,12) var num : int = 1
var is_hidden : bool = true
# TODO: have the index of the card in its parent saved in card itself?
# TODO: recreate + fix bug of card sliding far forward when stacking tabluea
# TODO: maybe switch to global position for return card to avoid headaches
# TODO: maybe use a state machine for cards.
func _ready() -> void:
	set_process(false)

func flip_card()->void:
	# Change cards suit and num for consistancy
	var new_frame=Vector2i(num,sprite_dict.find_key(suit))
	if not(is_hidden):
		new_frame=Vector2i(sprite_dict["hidden_column"],sprite_dict[Global.Suit.HIDDEN])
		is_hidden=true
		disable()
	else:
		is_hidden=false
		enable() #TODO: might be a problem for stockpile
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "scale:x", 0, 0.5)
	tween.tween_property(sprite, "frame_coords", new_frame,0)
	tween.tween_property(sprite, "scale:x", 1,0.5)

func enable()->void:
	$Click_Box/CollisionShape2D.disabled=false
	$Click_Box.monitorable=true
	$Click_Box.monitoring=true
	
func disable()->void:
	$Click_Box/CollisionShape2D.disabled=true
	$Click_Box.monitorable=false
	$Click_Box.monitoring=false	
	
func move_to(new_parent:Table_Element)->void:
	if parent:
		parent.remove_card(self,index) 
	new_parent.add_card(self)
	#reparent(new_parent) 
	parent=new_parent

func make_clickbox_stacksized():
	$Click_Box.scale.y = 0.2
	$Click_Box.position.y=-24
	
func reset_clickbox():
	$Click_Box.scale.y = 1
	$Click_Box.position.y=0	

func return_to_place()->void:
	var tween_drop = create_tween()
	tween_drop.set_ease(Tween.EASE_IN_OUT)
	#TODO: double check if global or local needed here 
	print("moving to ",current_position)
	tween_drop.tween_property($".","position",current_position,0.5)
	print("returned ",num," to ",self.get_parent(),parent)
	# TODO: fix issue with parent but not .get_parant() being set

func _process(delta: float) -> void:
	if in_hand: #TODO: i think this+set process being incorrectly handled. see: next to next todo
		global_position=get_global_mouse_position()
		if Input.is_action_just_released("Click"):
			in_hand=false
			set_process(false)
			# TODO: Make this if statements cleaner
			# TODO: Error: make sure parent is set!!
			var parent_area : Area2D = null
			if parent:
				parent_area=parent.get_node_or_null("Area")
			if not($Click_Box.has_overlapping_areas()) or $Click_Box.overlaps_area(parent_area):
				return_to_place()
				#TODO: fix: it sometimes gets called before current position gets 
				# updated but after its parent becomes another card
			
func _on_click_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click") and not(is_hidden):
		in_hand=true
		if parent:
			parent.move_to_front()
			#print(parent.name,current_position)
		set_process(true)
