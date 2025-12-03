class_name ArmContainer extends Area2D

@onready var chainsaw: Chainsaw = $"/root/Node2D/Chainsaw"

var target := Vector2.ZERO

@onready var _base_height := 60.0
@onready var _original_dir = Vector2.RIGHT if global_position.x < 0 else Vector2.LEFT
var _desired_height := -1.0

func player_hit(is_self: bool) -> void:
    if is_self:
        queue_free()
    else:
        _desired_height = get_parent().rope_len

func _ready() -> void:
    area_entered.connect(func(area):
        if area == chainsaw:
            if _desired_height < 0:
                _desired_height = (chainsaw.get_front_position() - global_position).length()
            GameManager.tug_over = true
    )

func _process(_delta: float) -> void:
    if not GameManager.tug_over:
        rotation = Vector2.DOWN.angle_to((target - global_position).normalized())
    else:
        rotation = Vector2.DOWN.angle_to(_original_dir)
    if _desired_height > 0:
        scale.y = _desired_height / _base_height
    else:
        scale.y = (target - global_position).length() / _base_height
