extends Node

const PORT := 9080
var udp := PacketPeerUDP.new()

var active_clients: Dictionary = {}
var slot_owners = { 1: "", 2: "" }

var time_since_last_heartbeat := 0.0

func _ready() -> void:
	add_to_group("NetworkBridge")
	var err = udp.bind(PORT)
	if err != OK:
		print("[UDP] Failed to bind on port %d: %s" % [PORT, err])
		return
	print("[UDP] Listening on port %d" % PORT)

func _process(_delta) -> void:
	var current_time = Time.get_ticks_msec()
	
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		var sender_ip = udp.get_packet_ip()
		var sender_port = udp.get_packet_port()
		var client_key = "%s:%d" % [sender_ip, sender_port]

		# Update last seen time
		if not active_clients.has(client_key):
			active_clients[client_key] = { "ip": sender_ip, "port": sender_port, "last_seen": current_time }
			print("[UDP] New client connected: ", client_key)
		else:
			active_clients[client_key]["last_seen"] = current_time

		var packet_type = packet[0]
		
		if packet_type == 1:
			_parse_binary_sensors(packet)
		else:
			var msg = packet.get_string_from_utf8()
			_parse_message(msg, sender_ip, sender_port, client_key)

	# Heartbeat and Timeout loop
	time_since_last_heartbeat += _delta
	if time_since_last_heartbeat >= 1.0: 
		var slots_changed = false
		var keys_to_remove = []
		
		for key in active_clients:
			var client = active_clients[key]
			# if no sensor recieved in 3 second, kick client
			if current_time - client["last_seen"] > 3000:
				keys_to_remove.append(key)
				if slot_owners[1] == key: slot_owners[1] = ""; slots_changed = true
				if slot_owners[2] == key: slot_owners[2] = ""; slots_changed = true
				print("[UDP] Client timed out: ", key)
			else:
				_send_to_specific_client("STATUS:ALIVE", client.ip, client.port)
		
		# Clean up afk
		for key in keys_to_remove:
			active_clients.erase(key)
			
		if slots_changed:
			_broadcast_slots()
			
		time_since_last_heartbeat = 0.0

func _parse_binary_sensors(packet: PackedByteArray) -> void:
	if packet.size() < 27: 
		print("[UDP-ERROR] Received incomplete packet. Size: ", packet.size(), " bytes")
		return 

	var player_id: int = packet[1]
	var sensor_sample = {
		"acc_x": packet.decode_float(2), "acc_y": packet.decode_float(6), "acc_z": packet.decode_float(10),
		"gyro_x": packet.decode_float(14), "gyro_y": packet.decode_float(18), "gyro_z": packet.decode_float(22),
		"gesture": packet[26] == 1
	}
	SignalBus.client_sensor_retrieved.emit(player_id, sensor_sample)

func _parse_message(msg: String, sender_ip: String, sender_port: int, client_key: String) -> void:
	if msg.begins_with("CMD:JOIN:"):
		var requested = int(msg.split(":")[2])
		var assigned = _assign_slot(client_key, requested)
		
		_send_to_specific_client("STATUS:ASSIGNED:%d" % assigned, sender_ip, sender_port)
		_broadcast_slots()
	
	elif msg == "CMD:PING":
		_send_to_specific_client("STATUS:PONG", sender_ip, sender_port)
		
	elif msg == "CMD:DISCONNECT":
		_remove_client(client_key)

func _assign_slot(client_key: String, requested: int) -> int:
	# If they already own a slot, give it right back to them
	if slot_owners[1] == client_key: return 1
	if slot_owners[2] == client_key: return 2
	
	# Requested empty? Will fill the selected slot
	if requested == 1 and slot_owners[1] == "":
		slot_owners[1] = client_key
		return 1
	if requested == 2 and slot_owners[2] == "":
		slot_owners[2] = client_key
		return 2
		
	# If their requested slot was taken, force them to the empty one
	if slot_owners[1] == "":
		slot_owners[1] = client_key
		return 1
	if slot_owners[2] == "":
		slot_owners[2] = client_key
		return 2
		
	return -1 # Slot is full
	
func _remove_client(client_key: String) -> void:
	if active_clients.has(client_key):
		active_clients.erase(client_key)
	
	var slots_changed = false
	
	if slot_owners[1] == client_key:
		slot_owners[1] = ""
		slots_changed = true
	
	if slot_owners[2] == client_key:
		slot_owners[2] = ""
		slots_changed = true
	
	if slots_changed:
		print("[UDP] Client explicitly disconnected. Freeing slot.")
		_broadcast_slots()
	
func _broadcast_slots() -> void:
	var msg = "STATUS:SLOTS:%s,%s" % [str(slot_owners[1] != ""), str(slot_owners[2] != "")]
	for key in active_clients:
		_send_to_specific_client(msg, active_clients[key].ip, active_clients[key].port)

func _send_to_specific_client(msg: String, ip: String, port: int) -> void:
	udp.set_dest_address(ip, port)
	udp.put_packet(msg.to_utf8_buffer())

func stop_connection() -> void:
	for key in active_clients:
		_send_to_specific_client("STATUS:DISCONNECTED", active_clients[key].ip, active_clients[key].port)
	udp.close()
	active_clients.clear()
	slot_owners = { 1: "", 2: "" }
