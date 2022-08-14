extends Node2D

var axys = Vector2(0, 0)
var velocidade = 50
var nome = ""

func _mudar_nome(novo_nome):
	nome = novo_nome
	$Label.text = novo_nome
	pass

func _process(delta):
	if is_network_master():
		if Input.is_action_pressed("b_cima"):
			axys.y = -1
		elif Input.is_action_pressed("b_baixo"):
			axys.y = 1
		else:
			axys.y = 0
		
		if Input.is_action_pressed("b_direita"):
			axys.x = 1
		elif Input.is_action_pressed("b_esquerda"):
			axys.x = -1
		else:
			axys.x = 0
		
		rpc("_atualizar_teclas", axys)
	position += axys * velocidade * delta
	if get_tree().is_network_server():
		rpc_unreliable("_atualizar_posicao", position)
	pass

remote func _atualizar_teclas(direcionais):
	axys = direcionais
	pass

remote func _atualizar_posicao(novapos):
	position = novapos
	pass
