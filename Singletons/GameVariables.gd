extends Node

const HALF_RED: Color = Color("54ff3c6d")
const HALF_GREEN: Color = Color("ff45456d")

const RED: Color = Color("54ff3ccd")
const GREEN: Color = Color("ff4545cd")

const RESET_POSITION: Vector2 = -Vector2.INF

const TURRETS: Dictionary = {
	"GunT1": {
		"damage": 20,
		"range": 350,
	},
	"MissleT1": {
		"damage": 100,
		"range": 550,
	},
}
