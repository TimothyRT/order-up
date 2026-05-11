extends Node

signal client_sensor_batch_received(player_id: int, data_dict: Dictionary)
signal client_sensor_retrieved(player_id: int, data_dict: Dictionary)
signal client_sensor_stored(player_id: int, sample_count: int)

signal classification_made(player_id: int, input_arr: Array, predicted_class: int)

signal avg_acc_y_changed(val: float)
signal peak_detected

signal room_entered
