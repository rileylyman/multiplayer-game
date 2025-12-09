class_name TennisBall extends Area2D

@export var speed: float = 400.0
@export var max_height: float = 100.0

@onready var sprite: Sprite2D = $Sprite
@onready var target_tracker: Sprite2D = $"../TargetTracker"

var _start: Vector2
var _target: Vector2
var _duration: float
var _elapsed: float

func _ready() -> void:
    on_ground_fall()
    body_entered.connect(func(body):
        if body is TennisPlayer:
            body.ball = self
    )

    body_exited.connect(func(body):
        if body is TennisPlayer:
            body.ball = null
    )

func on_ground_fall() -> void:
    if position.x > 0:
        global_position = Vector2(500, 0)
        hit_towards(Vector2(-500, 0))
    else:
        global_position = Vector2(-500, 0)
        hit_towards(Vector2(500, 0))

func hit_towards(target: Vector2) -> void:
    _target = target
    _start = global_position
    _duration = max((_target - _start).length() / speed, 1.5)
    _elapsed = 0.0

    target_tracker.global_position = _target

func is_near_ground() -> bool:
    return _elapsed / _duration > 0.75

func _process(delta: float) -> void:
    _elapsed += delta

    var t = _elapsed / _duration * 2.0 - 1.0
    global_position = _start.lerp(_target, (t + 1.0) / 2.0)
    if t > 1.1:
        on_ground_fall()

    var height = max_height * (1 - t * t)
    sprite.position.y = - height
