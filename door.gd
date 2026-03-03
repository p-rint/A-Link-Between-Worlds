extends Node3D

@export var plate : Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plate.plateFunction = doorFunction
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func doorFunction() -> void:
	print("noor!!!")
	visible = false
	
