extends Node

const PORT := 9080
var udp := PacketPeerUDP.new()

var active_clients: Dictionary = {}

var time_since_last_heartbeat := 0.0

func _ready() -> void:
	add_to_group("NetworkBridge")
	var err = udp.bind(PORT)
	if err != OK:
		print("[UDP] Failed to bind on port %d: %s" % [PORT, err])
		return
	print("[UDP] Listening on port %d" % PORT)
	print("[UDP] Local IP: ", IpAddress.ip)

func _process(_delta) -> void:
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		var sender_ip = udp.get_packet_ip()
		var sender_port = udp.get_packet_port()

		# Unique ID for each player's phone
		var client_key = "%s:%d" % [sender_ip, sender_port]

		if not active_clients.has(client_key):
			active_clients[client_key] = { "ip": sender_ip, "port": sender_port }
			print("[UDP] New client connected: ", client_key)

		var packet_type = packet[0]
		
		if packet_type == 1:
			_parse_binary_sensors(packet)
		else:
			var msg = packet.get_string_from_utf8()
			_parse_message(msg, sender_ip, sender_port)

	if not active_clients.is_empty():
		time_since_last_heartbeat += _delta
		if time_since_last_heartbeat >= 1.0: 
			for key in active_clients:
				var client = active_clients[key]
				_send_to_specific_client("STATUS:ALIVE", client.ip, client.port)
			time_since_last_heartbeat = 0.0

func _parse_binary_sensors(packet: PackedByteArray) -> void:
	if packet.size() < 27: 
		print("[UDP-ERROR] Received incomplete packet. Size: ", packet.size(), " bytes")
		return 
	var player_id: int = packet[1]
	#print("[UDP-RAW] ", player_id)
	var sensor_sample = {
		"acc_x": packet.decode_float(2),
		"acc_y": packet.decode_float(6),
		"acc_z": packet.decode_float(10),
		"gyro_x": packet.decode_float(14),
		"gyro_y": packet.decode_float(18),
		"gyro_z": packet.decode_float(22),
		"gesture": packet[26] == 1
	}
	#print("[UDP-SENSOR] P%d | Acc(%.2f, %.2f, %.2f) | Gyro(%.2f, %.2f, %.2f) | Gesture: %s" % [
		#player_id,
		#sensor_sample.acc_x, sensor_sample.acc_y, sensor_sample.acc_z,
		#sensor_sample.gyro_x, sensor_sample.gyro_y, sensor_sample.gyro_z,
		#str(sensor_sample.gesture)
	#])
	SignalBus.client_sensor_retrieved.emit(player_id, sensor_sample)

func _parse_message(msg: String, sender_ip: String, sender_port: int) -> void:
	if msg.begins_with("CMD:") or msg.begins_with("AXIS:") or msg.begins_with("BTN:"):
		_handle_command(msg, sender_ip, sender_port)
		return

func _handle_command(msg: String, sender_ip: String, sender_port: int) -> void:
	match msg:
		"CMD:PING":
			print("[UDP] Received PING from client %s:%d — sending PONG" % [sender_ip, sender_port])
			_send_to_specific_client("STATUS:PONG", sender_ip, sender_port)
		_:
			print("[UDP] Unknown command: ", msg)

func _send_to_specific_client(msg: String, ip: String, port: int) -> void:
	udp.set_dest_address(ip, port)
	udp.put_packet(msg.to_utf8_buffer())

func stop_connection() -> void:
	print("[UDP] Shutting down, notifying all clients...")
	for key in active_clients:
		var client = active_clients[key]
		_send_to_specific_client("STATUS:DISCONNECTED", client.ip, client.port)
	
	udp.close()
	active_clients.clear()
