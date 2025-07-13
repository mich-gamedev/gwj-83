class_name SaveData extends Resource

#region exports

#endregion

#region load options
const PATH: String = "user://save.tres"
const LOAD_ON_INIT: bool = true
#endregion

static var data: SaveData

static func save(to: String = "") -> Error:
	return ResourceSaver.save(data, to if to else PATH)

static func grab_or_create(from: String = "") -> void:
	from = from if from else PATH
	if ResourceLoader.exists(from):
		data = load(from)
	data = SaveData.new()
	save()

static func _static_init() -> void:
	if LOAD_ON_INIT: grab_or_create()
