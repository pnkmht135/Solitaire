extends Node

enum Suit {
	HEART,
	DIAMOND,
	SPADE,
	CLOVER,
	HIDDEN
}

var sprite_dict = {
	Suit.HEART : 0,
	Suit.DIAMOND : 1,
	Suit.SPADE : 2,
	Suit.CLOVER : 3,
	Suit.HIDDEN : 4,
	"hidden_column": 0,
	"none_row" : 4,
	"none_columb" : 1
}
