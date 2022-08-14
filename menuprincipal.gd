extends Control

func _process(delta):
	_atualizar_lista()
	if Networking._falha_conexao():
		$mensagem.show()
	pass

func _on_criar_pressed():
	Networking._atualizar_ip($ipconfig.text)
	Networking._atualizar_nome($nomeconfig.text)
	Networking._criar_servidor()
	$ipconfig.text = Networking._retornar_ip_servidor()
	$ipconfig.editable = false
	$criar.disabled = true
	$entrar.disabled = true
	pass

func _on_entrar_pressed():
	Networking._atualizar_ip($ipconfig.text)
	Networking._atualizar_nome($nomeconfig.text)
	Networking._entrar_servidor()
	$criar.disabled = true
	$entrar.disabled = true
	pass

func _atualizar_lista():
	var lista = Networking._retornar_lista_jogadores()
	var meuid = Networking._retornar_id()
	$listaconectados.clear()
	for i in range(lista.size()):
		var texto = lista[i][1]
		if lista[i][0] == meuid:
			texto += " (você)"
		$listaconectados.add_item(texto)
	pass

func _on_iniciar_pressed():
	Networking._iniciar_jogo()
	pass

func _on_mensagem_confirmar_pressed():
	Networking._resetar_conexao()
	$mensagem.hide()
	$ipconfig.editable = true
	$iniciar.disabled = false
	$entrar.disabled = false
	$criar.disabled = false
	pass
