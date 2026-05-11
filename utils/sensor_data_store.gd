extends Node


const SAMPLING_RATE := 0.033  # 30Hz

var player_data: Dictionary = {}

var buffer_max_size := 100
var last_update_time := 0.0  # in seconds

var data_dict = {
	"gyro_x": [],
	"gyro_y": [],
	"gyro_z": [],
	"acc_x": [],
	"acc_y": [],
	"acc_z": [],
	"gesture": []
}

func _ready() -> void:
	SignalBus.client_sensor_retrieved.connect(_on_client_sensor_retrieved)
	
func _init_player_buffer(player_id: int) -> void:
	if not player_data.has(player_id):
		player_data[player_id] = {
			"gyro_x": [], "gyro_y": [], "gyro_z": [],
			"acc_x": [], "acc_y": [], "acc_z": [],
			"gesture": []
		}

func _on_client_sensor_retrieved(player_id: int, _data_dict: Dictionary) -> void:
	_init_player_buffer(player_id)
	
	var p_data = player_data[player_id]
	
	# Append new data to certain player
	for key in _data_dict:
		p_data[key].append(_data_dict[key])
		
	# Slice the arrays if they exceed max buffer size
	if len(p_data["gesture"]) > buffer_max_size:
		var excess = len(p_data["gesture"]) - buffer_max_size
		for k in p_data:
			p_data[k] = p_data[k].slice(excess)
			
	# Sending spesific player of data sensor
	SignalBus.client_sensor_stored.emit(player_id, 1)
