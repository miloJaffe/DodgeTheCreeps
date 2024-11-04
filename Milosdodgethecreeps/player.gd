extends Area2D
signal hit
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var touhou = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	speed = 400
	if touhou == true:
		speed = 300
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	# See the note below about the following boolean assignment.
	if velocity.y < 0:
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false
	if Input.is_action_pressed("tmode"):
		touhou = true
		$CPUParticles2D.visible = true
		$CollisionShape2D.scale.x = .75
		$CollisionShape2D.scale.y = .75
	else:
		touhou = false
		$CPUParticles2D.visible = false
		$CollisionShape2D.scale.x = 1
		$CollisionShape2D.scale.y = 1

func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
