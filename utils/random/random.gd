extends Node


var rng := RandomNumberGenerator.new()
var play_seed = randi()


func reseed(level_arr: Array):
	seed(hash([play_seed, level_arr]))
