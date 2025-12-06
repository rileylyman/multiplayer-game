class_name Hole extends Area2D

enum HumanState {
    HIDDEN,
    PEEK,
    SHOWN,
    DEAD,
    REBUFF
}

@onready var human: Area2D = $ClipMask/Human
@onready var human_sprite: Sprite2D = $ClipMask/Human/Sprite
@onready var player1: WhackAPlayer = $"/root/SceneRoot/WhackAPlayer"
@onready var player2: WhackAPlayer = $"/root/SceneRoot/WhackAPlayer2"

@export var human_hidden_height := 0.0
@export var human_peek_height := 0.0
@export var human_shown_height := 0.0

@export var peek_duration := 2.0
@export var shown_duration := 2.0
@export var dead_duration := 0.5
@export var dead_rebuff_duration := 4.0

var human_state := HumanState.HIDDEN
var _state_elapsed := 0.0

func _ready() -> void:
    _switch_state(HumanState.HIDDEN)

func _process(delta: float) -> void:
    _state_elapsed += delta
    match human_state:
        HumanState.HIDDEN:
            _handle_hidden()
        HumanState.PEEK:
            _handle_peek()
        HumanState.SHOWN:
            _handle_shown()
        HumanState.DEAD:
            _handle_dead()
        HumanState.REBUFF:
            _handle_rebuff()

func _switch_state(new_state: HumanState) -> void:
    human_state = new_state
    _state_elapsed = 0
    var tween = create_tween()
    var tween_time = 0.1
    match new_state:
        HumanState.HIDDEN:
            tween.tween_property(human, "position:y", human_hidden_height, tween_time)
        HumanState.PEEK:
            tween.tween_property(human, "position:y", human_peek_height, tween_time)
        HumanState.SHOWN:
            tween.tween_property(human, "position:y", human_shown_height, tween_time)
        HumanState.DEAD:
            tween.tween_property(human, "position:y", human_shown_height, tween_time)
        HumanState.REBUFF:
            tween.tween_property(human, "position:y", human_hidden_height, tween_time)

func _handle_hidden() -> void:
    if randf() < 0.001:
        _switch_state(HumanState.PEEK)
        return

func _handle_peek() -> void:
    if overlaps_body(player1) or overlaps_body(player2):
        _switch_state(HumanState.HIDDEN)
        return
    if _state_elapsed > peek_duration:
        _switch_state(HumanState.SHOWN)

func _handle_shown() -> void:
    if _state_elapsed > shown_duration:
        _switch_state(HumanState.HIDDEN)
        return

    var player1_bite = human.overlaps_body(player1) and player1.is_biting()
    var player2_bite = human.overlaps_body(player2) and player2.is_biting()
    if player1_bite or player2_bite:
        _switch_state(HumanState.DEAD)
        if player1_bite:
            player1.freeze()
            GameManager.add_score(1, Utils.PlayerType.PLAYER_1)
        if player2_bite:
            player2.freeze()
            GameManager.add_score(1, Utils.PlayerType.PLAYER_2)
        return

func _handle_dead() -> void:
    human_sprite.self_modulate = Color.RED
    if _state_elapsed > dead_duration:
        _switch_state(HumanState.REBUFF)

func _handle_rebuff() -> void:
    human_sprite.self_modulate = Color.WHITE
    if _state_elapsed > dead_rebuff_duration:
        _switch_state(HumanState.HIDDEN)
