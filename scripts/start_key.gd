class_name StartKey extends Sprite2D

@export var player := Utils.PlayerType.PLAYER_1
@export var speed := 10.0

@onready var clip_mask: Sprite2D = $ClipMask
@onready var sprite: Sprite2D = $ClipMask/Sprite
@onready var sprite_height: float = sprite.get_rect().size.y

var y_offset := 0.0
var is_ready := false

func _process(delta: float) -> void:
    if is_ready:
        return

    y_offset += delta * speed * (-1.0 if not Utils.is_player_action_pressed("button1", player) else 1.0)
    y_offset = clampf(y_offset, 0, sprite_height)

    if y_offset == sprite_height:
        is_ready = true

    clip_mask.position.y = - y_offset
    sprite.position.y = y_offset
