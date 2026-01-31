class_name Card
extends Node2D

# Note: card Clickbox disabled on default.
@onready var sprite: Sprite2D = %sprite
@onready var sprite_dict: Dictionary = Global.sprite_dict
var parent: Table_Element = null # is it in the stockpile or tableau or a pile
var index: int = 0
var in_hand: bool = false 
var current_position: Vector2 = Vector2(0,0)
var suit : Global.Suit = Global.Suit.HIDDEN
@export_range(0,12) var num : int = 1
var is_hidden : bool = true
var children: Array[Card] = []
var foundation_pile: Foundation_Pile

# TODO: optimisation ke liye try handle moving things all in the card itself
# i.e check if can add in the card, and if so, then call move_to here only, so then turn off masks on other area 2d

func _ready() -> void:
	is_hidden=true
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

#TODO: change so clickboxes imported @onready and not every time.
func enable()->void:
	$Click_Box/CollisionShape2D.disabled=false
	$Click_Box.monitorable=true
	$Click_Box.monitoring=true
	
func disable()->void:
	$Click_Box/CollisionShape2D.disabled=true
	$Click_Box.monitorable=false
	$Click_Box.monitoring=false
	
func move_to(new_parent:Table_Element)->void:
	in_hand = false
	if parent:
		parent.remove_card(self,index) 
	new_parent.add_card(self)
	#TODO: remove redundancies in next line
	parent=new_parent

func make_clickbox_stacksized():
	$Click_Box.scale.y = 0.2
	$Click_Box.position.y=-24
	
func reset_clickbox():
	$Click_Box.scale.y = 1
	$Click_Box.position.y= 0

func return_to_place(time=0.5)->void:
	in_hand=false # TODO: make this an assert
	var tween_drop = create_tween()
	tween_drop.set_ease(Tween.EASE_IN_OUT)
	tween_drop.tween_property($".","position",current_position,time)

func get_parent_area()->Area2D:
	if parent == null:
		return null
	if parent.get_node_or_null("Area")!=null:
		return parent.get_node_or_null("Area")
	return parent.get_node_or_null("Click_Opened")

func return_or_move()->void:
	if $Click_Box.overlaps_area(get_parent_area()):
		return_to_place()
		return
	var overlapping_areas: Array[Area2D] = $Click_Box.get_overlapping_areas()
	for area in overlapping_areas: # TODO: maybe dont use for loop
		var area_parent=area.get_parent()
		print(area_parent.name) #potential BUG here/in tablue code when this happends
		if area_parent.can_add_card(self):
			move_to(area_parent)
			return
	print("No relavent overlapping areas.")
	return_to_place()
	
func _process(delta: float) -> void:
	if in_hand: 
		global_position=get_global_mouse_position()
		if Input.is_action_just_released("Click"):
			in_hand=false # TODO: might need to handle hitbox size as well
			set_process(false)
			return_or_move()
			
func _on_click_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click") and not(is_hidden):
		in_hand=true
		if parent:
			parent.move_to_front()
		set_process(true)
	if event.is_action_pressed("Right Click"):
		if foundation_pile and foundation_pile.can_add_card(self):
			move_to(foundation_pile)

func party():
	disable()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite,"scale",Vector2(0,0),1)
	tween.tween_property(sprite,"rotation",360,1)
	
