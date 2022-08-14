extends Node2D

var num_jogadores = 0
onready var packed_jogador = preload("res://jogador.tscn")

func _ready():
	rpc("_jogador_preparado")
	if not get_tree().is_network_server():
		get_tree().paused = true
	for i in range(Networking.jogadores.size()):
		var o = packed_jogador.instance()
		o.position = Vector2(300, 200)
		add_child(o)
		o.set_network_master(Networking.jogadores[i][0])
		o._mudar_nome(Networking.jogadores[i][1])
		o.name = "jogador" + str(i)
		Networking._associar_node_jogador(i, o)
	pass

remotesync func _jogador_preparado():
	num_jogadores += 1
	if get_tree().is_network_server() and num_jogadores == Networking.jogadores.size():
		rpc("_comecar", num_jogadores)
	pass

remotesync func _comecar(num_jog):
	get_tree().paused = false
	num_jogadores = num_jog
	pass
