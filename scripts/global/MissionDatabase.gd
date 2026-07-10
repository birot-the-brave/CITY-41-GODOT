extends Node

const MISSIONS: Dictionary = {
	00: {
		"name": "Disk Insert",
		"description": "Reboot your protocols, and remember how to fight for the cause.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "move", "label": "WALK around using WASD or the LEFT ANALOG STICK.", "autosave": false},
			{"id": "jump", "label": "JUMP using SPACE, A or X.", "autosave": false},
			{"id": "sprint", "label": "SPRINT using SHIFT or by pressing down the LEFT ANALOG STICK.", "autosave": false},
			{"id": "crouch", "label": "CROUCH using LEFT CTRL or pressing down the RIGHT ANALOG STICK.", "autosave": true},
		]
	},
}
