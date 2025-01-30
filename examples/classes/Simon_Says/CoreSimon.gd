extends Node

var next_pattern : Array[int]
var next_pattern_length : int = 4

func set_pattern_length(length : int):
	next_pattern_length = length

func increase_pattern_length(amount : int):
	next_pattern_length += amount

func generate_next_pattern():
	next_pattern = []
	for i in range(0, next_pattern_length):
		next_pattern.push_back(randi_range(0, 3))
