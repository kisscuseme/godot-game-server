extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "192.168.0.19"
var port = 1912

func _ready():
	ConnectToServer()


func _process(_delta):
	if self.custom_multiplayer == null:
		return
	if not self.custom_multiplayer.has_network_peer():
		return
	self.custom_multiplayer.poll()


func ConnectToServer():
	network.create_client(ip, port)
	self.custom_multiplayer = gateway_api
	self.custom_multiplayer.root_node = self
	self.custom_multiplayer.network_peer = network
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")


func _OnConnectionFailed():
	print("Failed to connect to Game Server Hub")


func _OnConnectionSucceeded():
	print("Successfully connected to Game Server Hub")
	rpc_id(1, "RegisterGameServer", network.get_unique_id())


remote func ReceiveLoginToken(token):
	Game.expected_tokens.append(token)
