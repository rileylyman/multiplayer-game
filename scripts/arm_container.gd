class_name ArmContainer extends Area2D

@onready var chainsaw: Chainsaw = $"/root/SceneRoot/Chainsaw"
@onready var player: TugPlayer = get_parent()

var target := Vector2.ZERO

@onready var _base_height := 60.0
@onready var _original_dir = Vector2.RIGHT if global_position.x < 0 else Vector2.LEFT
var _desired_height := -1.0
var _has_set_score := false

func player_hit(is_self: bool) -> void:
    if is_self:
        queue_free()
    else:
        _desired_height = player.rope_len
        _update_score()

func _ready() -> void:
    area_entered.connect(func(area):
        if area == chainsaw:
            if _desired_height < 0:
                _desired_height = (chainsaw.get_front_position() - global_position).length()
                _update_score()
            player.tug_over = true
    )

func _update_score() -> void:
    if _has_set_score:
        return
    _has_set_score = true
    GameManager.add_score(round(_desired_height / 20.0), player.player)


func _process(_delta: float) -> void:
    if not player.tug_over:
        rotation = Vector2.DOWN.angle_to((target - global_position).normalized())
    else:
        rotation = Vector2.DOWN.angle_to(_original_dir)
    if _desired_height > 0:
        scale.y = _desired_height / _base_height
    else:
        scale.y = (target - global_position).length() / _base_height
