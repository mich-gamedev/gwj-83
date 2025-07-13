@tool
extends EditorPlugin

var timer = Timer.new()

const og_setting = "editor/movie_writer/movie_file"
const new_setting = "editor/movie_writer/movie_file_without_timestamp"

func _enter_tree():
	
	ProjectSettings.set_setting(new_setting, "")
	ProjectSettings.set_initial_value(new_setting, "")
	ProjectSettings.add_property_info({
		"name": new_setting,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_GLOBAL_SAVE_FILE,
		"hint_string": "*.avi,*.png"
	})
	ProjectSettings.set_as_internal(og_setting, true)
	ProjectSettings.set_setting(new_setting, ProjectSettings.get_setting(og_setting))
	ProjectSettings.set_order(new_setting, ProjectSettings.get_order(og_setting))
	
	add_child(timer)
	timer.one_shot = false
	timer.start(1)
	timer.timeout.connect(_update_movie_file_path)

func _update_movie_file_path():
	
	var timestamp = Time.get_datetime_string_from_system().replace(":", ".").replace("T", "_")
	
	var path : String = ProjectSettings.get_setting(new_setting)
	var path_with_timestamp = path.get_basename() + "-" + timestamp + "." + path.get_extension() 
	
	ProjectSettings.set_setting(og_setting, path_with_timestamp)

func _exit_tree():
	timer.stop()
	timer.queue_free()
	
	ProjectSettings.set_setting(og_setting, ProjectSettings.get_setting(new_setting))
	ProjectSettings.set_setting(new_setting, null)
	ProjectSettings.set_as_internal(og_setting, false)
