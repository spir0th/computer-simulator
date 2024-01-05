extends Node

var addons = ["DebugMenu", "WindowportResizer", "FreeMyHomies"]

func _ready():
	for a in addons:
		var node = get_tree().root.get_node_or_null("/root/%s" % a)
		
		if node == null:
			print("FreeMyHomies: Process mode for %s cannot be set to ALWAYS, skipping." % a)
			continue
		
		node.process_mode = Node.PROCESS_MODE_ALWAYS
