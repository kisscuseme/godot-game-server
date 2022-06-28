extends GameServerMethods

var network = NetworkedMultiplayerENet.new()
var port = GlobalData.server_info["GAME_SERVER_1"]["PORT"]
var max_players = 100

func _ready():
	StartServer()

func StartServer():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("Server started")
	
	network.connect("peer_connected", self, "_Peer_Connected")
	network.connect("peer_disconnected", self, "_Peer_Disconnected")


func _Peer_Connected(player_id):
	print("User " + str(player_id) + " Connected")
	if not GlobalData.skip_auth:
		GlobalData.player_verification_process.start(player_id)
	else:
		GlobalData.player_verification_process.CreatePlayerContainer(player_id)


func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")
	if self.has_node(str(player_id)):
		self.get_node(str(player_id)).queue_free()
		GlobalData.player_state_collection.erase(player_id)
		rpc_id(0, "DespawnPlayer", player_id)


func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if GlobalData.expected_tokens == []:
		pass
	else:
		for i in range(GlobalData.expected_tokens.size() -1, -1, -1):
			token_time = int(GlobalData.expected_tokens[i].right(64))
			if current_time - token_time >= 30:
				GlobalData.expected_tokens.remove(i)
#	print("Expected Tokens: ", Game.expected_tokens)
