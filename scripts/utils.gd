extends Node2D

enum PlayerType {
    PLAYER_1,
    PLAYER_2
}

func get_global_viewport_rect() -> Rect2:
    return wssr()

func wssr() -> Rect2:
    return get_canvas_transform().affine_inverse() * get_viewport_rect()

func get_sprite_global_rect(s: Sprite2D) -> Rect2:
    return s.get_global_transform() * s.get_rect()

func is_player_action_just_pressed(action: String, player: PlayerType) -> bool:
    if player == PlayerType.PLAYER_1:
        return Input.is_action_just_pressed(action)
    else:
        return Input.is_action_just_pressed(action + "_alt")

func is_player_action_pressed(action: String, player: PlayerType) -> bool:
    if player == PlayerType.PLAYER_1:
        return Input.is_action_pressed(action)
    else:
        return Input.is_action_pressed(action + "_alt")

func get_player_move_vector(action_left: String, action_right: String, action_up: String, action_down: String, player: PlayerType) -> Vector2:
    if player == PlayerType.PLAYER_1:
        return Input.get_vector(action_left, action_right, action_up, action_down)
    else:
        return Input.get_vector(action_left + "_alt", action_right + "_alt", action_up + "_alt", action_down + "_alt")
