extends Camera2D

@onready var timer : Timer = $Timer
@onready var tween : Tween = create_tween()
@onready var ShakeAmount

func _ready() -> void:
	set_process(false)
	randomize()

func _process(_delta: float) -> void:
	offset = Vector2(randf_range(-1, 1) * ShakeAmount, randf_range(-1, 1) * ShakeAmount)

func shake(time: float, amount: float):
	timer.wait_time = time
	ShakeAmount = amount
	set_process(true)
	timer.start()


func _on_timer_timeout() -> void:
	set_process(false)
	Tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
