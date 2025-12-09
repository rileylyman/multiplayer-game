class_name ArmContainer extends Area2D

@onready var chainsaw: Chainsaw = $"/root/SceneRoot/Chainsaw"
@onready var player: TugPlayer = get_parent()
@onready var arm_mask: Sprite2D = $ArmMask
@onready var arm_sprite: Sprite2D = $ArmMask/Sprite2D

@onready var arm_mask_original_pos: Vector2 = arm_mask.position
@onready var arm_sprite_original_pos: Vector2 = arm_sprite.position

var target := Vector2.ZERO

@onready var _base_height := 152.0
@onready var _original_dir = Vector2.RIGHT if global_position.x < 0 else Vector2.LEFT
var _desired_height := -1.0
var _has_set_score := false

func player_hit(is_self: bool) -> void:
    if is_self:
        get_parent()._arm_container = null
        queue_free()
    else:
        _desired_height = _base_height 
        _update_score()

func _ready() -> void:
    if player.player == Utils.PlayerType.PLAYER_2:
        arm_sprite.rotation += PI
    area_entered.connect(func(area):
        if area == chainsaw:
            if _desired_height < 0:
                var total = (player.other_player.get_mouth_pos() - player.get_mouth_pos()).length()
                var ratio = (chainsaw.get_front_position() - player.get_mouth_pos()).length() / total
                _desired_height = ratio * _base_height
                _update_score()
                player.need_back_burst = true
            player.tug_over = true
    )

func _update_score() -> void:
    if _has_set_score:
        return
    _has_set_score = true
    GameManager.add_score(round(_desired_height), player.player)


func _process(_delta: float) -> void:
    if not player.tug_over:
        rotation = Vector2.DOWN.angle_to((target - global_position).normalized())
    else:
        rotation = Vector2.DOWN.angle_to(_original_dir)

    if _desired_height > 0:
        if player.player == Utils.PlayerType.PLAYER_2:
            if player.other_player._arm_container != null:
                _desired_height = _base_height - player.other_player._arm_container._desired_height
        # scale.y = _desired_height / _base_height
        scale.y = 1.0
        arm_mask.position.y = arm_mask_original_pos.y - (_base_height - _desired_height)
        arm_sprite.position.y = arm_sprite_original_pos.y + 1.0 / arm_mask.global_scale.y * (_base_height - _desired_height)
    else:
        scale.y = (target - global_position).length() / _base_height
