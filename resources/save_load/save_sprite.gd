extends TextureButton
class_name Save_Load_Resource

const SAVE_PATH = "user://saves/"
const SAVE_FILE_PATH = "clicker_save.json"
const SECURITY_KEY = "@Oi3!m%F259#"

func _ready() -> void:
	### WARNING: FUTURE RELEASES
	verify_save_directory(SAVE_PATH)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save_data(path: String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
		
	var data = {
		"clicker_data":{
			"clicks": Global.clicker_data.clicks,
			"clicks_result": Global.clicker_data.clicks_result,
			"clicks_modify": Global.clicker_data.clicks_modify
		},
		"progress_data":{
			"name": Global.progress_data.name,
			"race": Global.progress_data.race,
			"classes": Global.progress_data.classes,
			"stats": Global.progress_data.stats,
			"Health": Global.progress_data.character_atributes["Health"],
			"Max_Health": Global.progress_data.character_atributes["Max_Health"],
			"Mana": Global.progress_data.character_atributes["Mana"],
			"Max_Mana": Global.progress_data.character_atributes["Max_Mana"],
			"Exp": Global.progress_data.character_atributes["Exp"],
			"Exp_Max": Global.progress_data.character_atributes["Exp_Max"],
			"Level": Global.progress_data.character_atributes["Level"],
			"Gold": Global.progress_data.character_atributes["Gold"],
			"Context": Global.progress_data.context
		}
	}
	
	var json_string = JSON.stringify(data,"\t")
	file.store_string(json_string)
	file.close()
	
func load_clicker_data(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
		
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			printerr("error parse")
			return
		
		Global.clicker_data.clicks = data.clicker_data.clicks
		Global.clicker_data.clicks_result = data.clicker_data.clicks_result
		Global.clicker_data.clicks_modify = data.clicker_data.clicks_modify
		
	else:
		printerr("imposibilitado de abrir um arquivo nao-existente em %s" % [path])
	
func save_pressed():
	save_data(SAVE_PATH + SAVE_FILE_PATH)
	print("saved")

func load_pressed():
	load_clicker_data(SAVE_PATH + SAVE_FILE_PATH)
	print("loaded")
