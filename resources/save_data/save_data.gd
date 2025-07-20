class_name SaveData extends Resource

#region exports
@export var high_score: int
@export var played_before: bool
@export var vsync: bool = true
@export var fullscreen: bool
@export var music: int = 5
@export var sfx: int = 5
#endregion

#region load options
const PATH: String = "user://save.tres"
#endregion

static var data: SaveData

func update() -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if data.vsync else DisplayServer.VSYNC_DISABLED)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if data.fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_linear(1, data.music/10.)
	AudioServer.set_bus_volume_linear(2, data.sfx/10.)

static func save(to: String = "") -> Error:
	data.update()
	return ResourceSaver.save(data, to if to else PATH)

static func grab_or_create(from: String = "") -> void:
	from = from if from else PATH
	if ResourceLoader.exists(from):
		data = load(from)
		data.update()
		return
	data = SaveData.new()
	data.update()
	save()
