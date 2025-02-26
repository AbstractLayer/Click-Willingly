extends Resource
class_name Progress_Resource

@export_category("Base Atributes")
@export var random_names: Array[String] = ["Lucas o ed", "Nicoextreme", "Ratib", "Marte", "Lostopazio",
										   "Barao", "Fidelcastro", "Mosame", "Irritadinho",
										   "Kaike Araujo"]
@export var name : String
@export var race : String
@export var classes : String
@export var stats : Array[String]
@export var character_atributes : Dictionary = {
	"Health": 0,
	"Max_Health": 0,
	"Mana": 0,
	"Max_Mana": 0,
	"Level": 0,
	"Gold": 0,
	"Exp": 0,
	"Exp_Max": 250
}
@export var context : int

@export_category("Character Development")
@export var equipament : Array[String]
@export var inventory : Array[String]
@export var quests : Array[String]
@export var skills : Array[String]

@export_category("Basic Info")
@export var enemies_titles : Array[String] = ["Sr.","Sra."]
@export var enemies_impressive_titles : Array[String] = ["Lorde","Rei"]
@export var kill_variants : Array[String] = ["Executing","Killing","Assassinating","Hurting","Succumbing"]
@export_category("Cruz-credo Environment")
@export var cruz_equipaments : Array[String] = ["soquete monstro"]
@export var cruz_spells : Array[String] = ["fogo pelado"]
@export var cruz_enemies : Array[String] = ["an evil orc", "a bat", "an mad archer", "a crazy scientist",
											"a careful barbarian", "an ugly", "a cockroach"]
@export var cruz_enemies_loot: Array[String] = ["perna do orc"]
@export var cruz_places : Array[String] = ["main hall", "kitchen","alley with a exit", "guest room",
											"haunted basement", "delicate greenhouse", "tiny room"]
@export var cruz_sell_places : Array[String] = ["comedor de abraçadeiras"]
@export var cruz_secret : Array[String] = ["olha pro ceu"]
