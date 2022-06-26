extends Node

func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if Game.expected_tokens == []:
		pass
	else:
		for i in range(Game.expected_tokens.size() -1, -1, -1):
			token_time = int(Game.expected_tokens[i].right(64))
			if current_time - token_time >= 30:
				Game.expected_tokens.remove(i)
#	print("Expected Tokens: ", Game.expected_tokens)
