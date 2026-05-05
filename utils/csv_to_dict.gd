extends Node


func load_csv(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	var headers = file.get_csv_line()
	var dict_list = []
	
	while !file.eof_reached():
		var row_data = file.get_csv_line()
		if row_data.size() == headers.size():
			var row_dict = {}
			for i in range(headers.size()):
				row_dict[headers[i]] = row_data[i]
			dict_list.append(row_dict)
	
	return dict_list
