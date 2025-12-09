extends Node2D

const splatter_scene: PackedScene = preload("res://scenes/splatter.tscn")

@export var splatter_count := 100

func _ready() -> void:
    for i in range(splatter_count):
        var splatter = splatter_scene.instantiate()
        add_child(splatter)
        splatter.position = Vector2(randf_range(-200, 200), randf_range(-100, 100))
        splatter.scale = Vector2(randf_range(0.2, 1.5), randf_range(0.2, 1.5))
        splatter.rotation = randf_range(-PI, PI)
        splatter.find_child("Sprite2D").self_modulate = Color.from_hsv(1, 1, randf_range(0.5, 1))
