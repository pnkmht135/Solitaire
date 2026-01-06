extends Node

enum Suit {
	HEART,
	DIAMOND,
	SPADE,
	CLOVER,
	HIDDEN,
	NONE
}

var sprite_dict = {
	Suit.HEART : 0,
	Suit.DIAMOND : 1,
	Suit.SPADE : 2,
	Suit.CLOVER : 3,
	Suit.HIDDEN : 4,
	"hidden_column": 0,
	Suit.NONE : 4,
	"none_columm" : 1
} #TODO: find a way to avoid messy strings!
