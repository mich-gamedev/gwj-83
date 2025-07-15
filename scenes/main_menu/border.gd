@tool extends ReferenceRect

@export var width: float:
	set(v):
		width = v
		size.x = v
@export var height: float:
	set(v):
		height = v
		size.y = v
@export var pos_x: float:
	set(v):
		pos_x = v
		position.x = v
@export var pos_y: float:
	set(v):
		pos_y = v
		position.y = v
