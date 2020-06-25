extends Area2D

onready var animated_sprite : AnimatedSprite = $AnimatedSprite

signal pressed
signal unpressed


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: PhysicsBody2D) -> void:
	pass


func _on_body_exited(body: PhysicsBody2D) -> void:
	pass


func _on_Switch_body_entered(body):
	if body.get_name() != "Player":
		return
	animated_sprite.play("down")
	emit_signal("pressed")


func _on_Switch_body_exited(body):
	if body.get_name() != "Player":
		return
	animated_sprite.play("up")
	emit_signal("unpressed")
