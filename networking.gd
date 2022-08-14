extends Node

const IPPADRAO = "127.0.0.1"
const PORTAPADRAO = 6007
const MAXJOGADORES = 5

var ip = IPPADRAO
var nome = "Jogador"
var ID = ""
var jogadores = []
var peer = null
var falha_conexao = false

func _ready():
	get_tree().connect("connected_to_server", self, "_conectado_ao_servidor")
	get_tree().connect("server_disconnected", self, "_queda_do_servidor")
	get_tree().connect("connection_failed", self, "_conexao_nao_sucedida")
	jogadores.clear()
	pass

func _conectado_ao_servidor():
	rpc("_registar_jogador", get_tree().get_network_unique_id(), nome)
	pass

func _cliente_desconectado(id):
	rpc("_remover_jogador", id)
	pass

func _queda_do_servidor():
	if not get_tree().current_scene.name == "principal":
		get_tree().change_scene("res://menuprincipal.tscn")
	falha_conexao = true
	get_tree().set_network_peer(null)
	pass

func _conexao_nao_sucedida():
	falha_conexao = true
	pass

func _falha_conexao():
	return falha_conexao
	pass

func _resetar_conexao():
	ip = IPPADRAO
	nome = "Jogador"
	ID = ""
	jogadores.clear()
	peer = null
	falha_conexao = false
	pass

remote func _registar_jogador(id, nome):
	if get_tree().is_network_server():
		for i in range(jogadores.size()):
			rpc_id(id, "_registar_jogador", jogadores[i][0], jogadores[i][1])
		rpc("_registar_jogador", id, nome)
	jogadores.append([id, nome])
	pass

func _associar_node_jogador(id_jogador, node):
	jogadores[id_jogador].append(node)
	pass

remotesync func _remover_jogador(id):
	for i in range(jogadores.size()):
		if jogadores[i][0] == id:
			jogadores[i][2].queue_free()
			jogadores.remove(i)
	pass

func _atualizar_ip(novoip):
	ip = novoip
	pass

func _atualizar_nome(novonome):
	nome = novonome
	pass

func _retornar_lista_jogadores():
	return jogadores
	pass

func _retornar_id():
	return ID
	pass

func _retornar_ip_servidor():
	var ips = IP.get_local_addresses()
	for i in range(ips.size()):
		if ips[i].begins_with("192"):
			return ips[i]
	pass

func _criar_servidor():
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORTAPADRAO, MAXJOGADORES)
	get_tree().set_network_peer(peer)
	ID = get_tree().get_network_unique_id()
	peer.connect("peer_disconnected", self, "_cliente_desconectado")
	_registar_jogador(ID, nome)
	pass
	
func _entrar_servidor():
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, PORTAPADRAO)
	get_tree().set_network_peer(peer)
	ID = get_tree().get_network_unique_id()
	pass

func _iniciar_jogo():
	if get_tree().is_network_server() and jogadores.size() > 1:
		rpc("_trocar_cena")
	pass

remotesync func _trocar_cena():
	get_tree().change_scene("res://fase.tscn")
	pass
