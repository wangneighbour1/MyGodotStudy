extends Area2D

signal hit

@export var speed = 200
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var Velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		Velocity.y += 1	
	if Input.is_action_pressed("move_left"):
		Velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		Velocity.x += 1
	if Input.is_action_pressed("move_up"):
		Velocity.y -= 1
		
	if Velocity.length()>0:
		Velocity = Velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += Velocity * delta
	position = position.clamp(Vector2.ZERO , screen_size)
	
	if Velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = Velocity.x < 0
	elif Velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = Velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled" , true)
