class_name Card
extends Node2D

@onready var sprite: Sprite2D = %sprite
@onready var sprite_dict: Dictionary = Global.sprite_dict
@export var suit : Global.Suit = Global.Suit.HIDDEN
@export_range(0,12) var num : int = 1
@export var is_hidden : bool = true
# TODO: make a custom date type for a card consisting of both sprite and num
# should have num restricted to 1-13/0-12 (mod 13 shit fr fr)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func flip_card()->void:
	# Change cards suit and num for consistancys
	print(is_hidden)
	var new_frame=Vector2i(num,suit)
	if not(is_hidden):
		new_frame=Vector2i(sprite_dict["hidden_column"],sprite_dict[Global.Suit.HIDDEN])
		is_hidden=true
	else:
		is_hidden=false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "scale:x", 0, 0.25)
	tween.tween_property(sprite, "frame_coords", new_frame,0)
	tween.tween_property(sprite, "scale:x", 1,0.25)
	# TODO: how to clear tween idk
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if not(is_hidden):
		#flip_card(num,suit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
