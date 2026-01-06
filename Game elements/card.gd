class_name Card
extends Node2D
@onready var sprite: Sprite2D = %sprite
@onready var sprite_dict: Dictionary = Global.sprite_dict
@export var suit : Global.Suit = Global.Suit.HIDDEN
@export_range(0,12) var num : int = 0
@export var is_hidden : bool = true
# TODO: make a custom date type for a card consisting of both sprite and num
# should have num restricted to 1-13/0-12 (mod 13 shit fr fr)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	##if not(is_hidden):
	#var flip_anim: Animation=animation_player.get_animation("Flip card")
	#var flip_sprite_track=flip_anim.find_track("sprite", Animation.TYPE_VALUE)
	##var flip_sprite_track=flip_anim.find_track(sprite.get_path(), Animation.TYPE_VALUE)
	#
	#print(flip_sprite_track) #not finding thing
	## TODO : fix this hadcoding path nonsense 
	#var flip_key_id=flip_anim.track_find_key(flip_sprite_track,0.5)
	#flip_anim.track_set_key_value(flip_sprite_track,flip_key_id,Vector2i(num,sprite_dict[suit]))
	#
	#animation_player.play("Flip card")
	#sprite.frame=10
	sprite.frame_coords=Vector2i(num,sprite_dict[suit])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
