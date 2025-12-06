extends AnimationPlayer

@export var instruction: Label

func _ready() -> void:
    instruction.text = GameManager.get_transition_instruction_text()
    play("main")
    await get_tree().create_timer(14.0).timeout
    GameManager.next_scene()
