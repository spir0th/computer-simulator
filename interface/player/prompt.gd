extends Control

@export var action = "player_interact"
@export var task = "Interact"

@onready var _action = $_/_/Action
@onready var _task = $_/_/Task

func _process(_delta):
	_action.action_name = action
	_task.text = task
