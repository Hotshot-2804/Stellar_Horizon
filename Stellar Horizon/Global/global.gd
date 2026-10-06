extends Node

# The Event Bus: Any script can listen to this signal
signal _meteor_destroyed(points: int)

var score := 0
var lives = 6