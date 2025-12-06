extends AnimationPlayer

func _ready() -> void:
    play("main")
    await get_tree().create_timer(14.0).timeout
    get_tree().change_scene_to_file("res://scenes/tug.tscn")
