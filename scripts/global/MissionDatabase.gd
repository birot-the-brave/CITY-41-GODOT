extends Node

const MISSIONS: Dictionary = {
	00: {
		"name": "Disk Insert",
		"description": "Reboot your protocols, and remember how to fight for the cause.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "walk", "label": "WALK around using WASD or the LEFT ANALOG STICK.", "autosave": false},
			{"id": "jump", "label": "JUMP using SPACE, or A/X on controller.", "autosave": false},
			{"id": "sprint", "label": "SPRINT using SHIFT or by pressing down the LEFT ANALOG STICK.", "autosave": false},
			{"id": "crouch", "label": "CROUCH using LEFT CTRL or o/B on controller.", "autosave": false},
			{"id": "collect_1", "label": "COLLECT your first weapon, the POWER PUNCH.", "autosave": false},
			{"id": "melee", "label": "ELIMINATE the enemy using F or pressing down the RIGHT ANALOG STICK.", "autosave": false},
			{"id": "collect_2", "label": "COLLECT the handgun forearm and EQUIP it by holding Q or Y/Triangle on controller, to open the WEAPON WHEEL.", "autosave": false},
			{"id": "lure", "label": "DISABLE the generator with your new gun to lure the GRUNTS outside.", "autosave": false},
			{"id": "enter", "label": "ENTER the premises.", "autosave": false},
			{"id": "clear", "label": "CLEAR out the GRUNTS using your new weapons, LMB or R3/RT to shoot, R or X/Square to reload.", "autosave": true},
			{"id": "exit", "label": "LEAVE the premises.", "autosave": true},
		]
	},
	01: {
		"name": "Press Start",
		"description": "",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	02: {
		"name": "2 Dirty Glasses",
		"description": "Meet with the contact to gain information on the warehouse.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	03: {
		"name": "Halispolec",
		"description": "Search the warehouse for information.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	04: {
		"name": "Triiviael",
		"description": "Hunt down the informant.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	05: {
		"name": "Facility",
		"description": "Make your way out of the city to damage important governmental infrastructure.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "infiltrate", "label": "Find a way into the facility without being exterminated.", "autosave": true},
			{"id": "breach", "label": "Push through enemy forces to find the facility's integral offices.", "autosave": false},
			{"id": "mainframe", "label": "Find the exit codes.", "autosave": false},
			{"id": "opening", "label": "Make your way to the exit and activate all signals to open it.", "autosave": false},
			{"id": "escape", "label": "Leave the city.", "autosave": true},
		]
	},
	0601: {
		"name": "Outside (REBEL)",
		"description": "Find the rebellion base outside the city.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	0602: {
		"name": "Outside (QUARRY)",
		"description": "Disable the system's mining pits to stop supplies reaching the factories.",
		"linear": false,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	0603: {
		"name": "Outside (FACTORIES)",
		"description": "Attempt to find out what is being produced in the factories.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	07: {
		"name": "Isopod",
		"description": "Enter and scout the first factory.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	08: {
		"name": "Small Machines",
		"description": "Enter and scout the second factory.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	09: {
		"name": "Kromosome",
		"description": "Enter and scout the final factory.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	10: {
		"name": "Isotope",
		"description": "Confront the ",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
	11: {
		"name": "Boss Battle",
		"description": "Demolish the governing power of City 41.",
		"linear": true,
		"autosave_on_complete": true,
		"objectives": [
			{"id": "", "label": "", "autosave": false},
		]
	},
}
