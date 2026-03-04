extends StaticBody3D

@export var plate : Area3D

var active = false
@onready var collider: CollisionShape3D = $CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plate.plateFunction = doorActivate
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	checkOverlaps()


func doorActivate() -> void:
	active = true
	print("noor!!!")
	visible = false
	collider.disabled = true

func doorDisable() -> void:
	active = false
	print("denoor!!!")
	visible = true
	collider.disabled = false
	

func checkOverlaps() -> void:
	var overlaps = plate.get_overlapping_areas()
	var found = false
	for i in overlaps:
		
		if i.get_parent().name == "Block":
			found = true
	
	if found:
		if not active:
			doorActivate()
	else:
		if active:
			doorDisable()
			
		
		
