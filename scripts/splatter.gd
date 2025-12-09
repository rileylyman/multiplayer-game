extends Area2D

var health := 7

func _process(_delta: float) -> void:
    modulate = Color(1, 1, 1, 0.1 + 0.9 * (health / 7.0))

func take_damage() -> bool:
    health -= 1
    if health <= 0:
        queue_free()
        return true
    return false