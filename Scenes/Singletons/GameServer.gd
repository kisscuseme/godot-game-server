extends GameServerMethods

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

onready var node = get_node("/root/Main")

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
	if not skip_auth:
		player_verification_process.start(player_id)
	else:
		player_verification_process.CreatePlayerContainer(player_id)


func _Peer_Disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")
	if node.has_node(str(player_id)):
		node.get_node(str(player_id)).queue_free()
		player_state_collection.erase(player_id)
		rpc_id(0, "DespawnPlayer", player_id)
