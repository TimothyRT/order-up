extends Node


const MAX_PEERS := 4
const PORT := 9080

var verbose := false
var ws_server := WebSocketMultiplayerPeer.new()
var connected_peers := []


func _ready() -> void:
	var err = ws_server.create_server(PORT)
	if err != OK:
		print("[SOCKET] Failed to start WebSocket server: %s" % err)
		return
	
	# Hook into peer connect/disconnect
	ws_server.peer_connected.connect(_on_peer_connected)
	ws_server.peer_disconnected.connect(_on_peer_disconnected)

	print("[SOCKET] WebSocket server listening on port %d" % PORT)
	print("[SOCKET] Local IP address: ", IpAddress.ip)


func _on_peer_connected(id: int):
	print("[SOCKET] Peer connected: ", id)
	connected_peers.append(id)


func _on_peer_disconnected(id: int):
	print("[SOCKET] Peer disconnected: ", id)
	connected_peers.erase(id)


func _process(_delta):
	ws_server.poll()
	
	if connected_peers.size() > 0:
		while ws_server.get_available_packet_count() > 0:
			var _id = ws_server.get_packet_peer()
			var pkt = ws_server.get_packet()

			var msg = pkt.get_string_from_utf8()
			if verbose:
				print("[SOCKET] Got from %d: %s" % [_id, msg])
			_parse_message(msg)


func _parse_message(msg: String):
	var parsed = JSON.parse_string(msg)
	if parsed != null:
		SignalBus.client_sensor_batch_received.emit(parsed)
