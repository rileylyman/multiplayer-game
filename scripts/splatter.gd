extends Area2D

var health := 7

func _process(_delta: float) -> void:
    modulate = Color(1, 1, 1, health / 10.0)

func take_damage() -> bool:
    health -= 1
    if health <= 0:
        queue_free()
        return true
    return false