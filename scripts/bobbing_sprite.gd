extends Sprite2D

@export var bob_speed := 4.0
@export var bob_height := -15.0

@onready var original_y := position.y
var bob_offset := 0.0

@onready var _phase_offset := randf_range(0.0, 2 * PI)

func _process(_delta: float) -> void:
    bob_offset = (sin(Time.get_ticks_msec() / 1000.0 * bob_speed + _phase_offset) - 1) / 2 * bob_height
    position.y = original_y + bob_offset
