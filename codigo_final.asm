#-------------------------------------------------------------------------
#		Organizacao e Arquitetura de Computadores - Turma C 
#			Trabalho 1 - Assembly RISC-V
#
# Nome: Iuri Sousa Vieira		Matricula: 16/0152488
# Nome: Wanderlan Alves 		Matricula: 16/0148782 

.data
	image_name:   		.asciz "lenaeye.raw"		# nome da imagem a ser carregada
	address: 		.word   0x10040000		# endereco do bitmap display na memoria	
	init:			.word   0x10043F00 		# posicao 0x0 do bitmap
	buffer:			.word   0			# configuracao default do RARS
	size:			.word	4096			# numero de pixels da imagem
	txt_menu:		.asciz "\nDefina o numero opcao desejada: \n1. Obtem ponto \n2. Desenha ponto \n3. Desenha retangulo com preenchimento \n4. Desenha retangulo sem preenchimento \n5. Converte para negativo da imagem \n6. Converte imagem para tons de vermelho \n7. Carrega imagem \n8. Encerra\n"
	txt_x:			.asciz "\nDigite o valor de x(0 a 63): "
	txt_y:			.asciz "\nDigite o valor de y(0 a 63): "
	txt_xi:			.asciz "\nDigite o valor de x inicial(0 a 63): "
	txt_yi:			.asciz "\nDigite o valor de y inicial(0 a 63): "
	txt_xf:			.asciz "\nDigite o valor de x final(0 a 63): "
	txt_yf:			.asciz "\nDigite o valor de y final(0 a 63): "
	txt_rgb:		.asciz "\nValor RGB do ponto desejado: "
	txt_val_r:		.asciz "\nDigite o valor desejado referente ao R do pixel(0 a 255): "
	txt_val_g:		.asciz "\nDigite p valor desejado referente ao G do pixel(0 a 255): "
	txt_val_b:		.asciz "\nDigite p valor desejado referente ao B do pixel(0 a 255): "
	txt_erro:		.asciz "\nValor digitado invalido, o programa retornara ao menu! \n\n"
	txt_space_line:		.asciz "\n"
	
.text
	# ------------------------------------------------------------------------
	# Funcao print_str: imprimir string na tela
	# Argumentos: 
	#   arg: recebe os caracteres que devem ser imprimidos na tela
	.macro print_str($arg)
		# chamada de sistema para imprimir strings na tela -> definida por a7=4 
		# parametros: a0 -> endereco da string que se quer imprimir
		# retorno: imprime uma string no console
		li	a7, 4		# a7=4 -> definicao da chamada de sistema para imprimir strings na tela
		la	a0, $arg	# a0=endereco da string "str0"
		ecall			# realiza a chamada de sistema
	.end_macro
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao verif: verificar se os valores digitados pelo usario sao validos
	# Argumentos: 
	#   arg: recebe o valor digitado pelo usuario
	#   val_i: recebe o valor inicial que é valido
	#   arg: recebe o valor final que é valido
	.macro verif($arg, $from, $to)
		mv t0, $arg		
		li t1, $from
		li t2, $to
		
		bge t0, t2, erro
		blt t0, t1, erro
					
	.end_macro
	
	erro:
		print_str(txt_erro)
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao val_x_y: recebe os valores de x e y digitados pelo usuario para usar nas funcoes get_point e draw_point
	.macro val_x_y
		
		print_str(txt_x)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s3, a0		# Transfere o valor de a0 pro registrador s3
		
		verif(s3, 0, 64)	# verifica se o valor digitado pelo usuario eh valido
		
		print_str(txt_y)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s4, a0		# Transfere o valor de a0 pro registrador s4
		
		verif(s3, 0, 64)	# verifica se o valor digitado pelo usuario eh valido
	.end_macro
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao val_xi_yi_xf_yf: recebe os valores de x e y inicial e final digitados pelo usuario para usar no draw_full_rectangle e draw_empty_rectangle
	.macro val_xi_yi_xf_yf
	
		print_str(txt_xi)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s3, a0		# Transfere o valor de a0 pro registrador s3
		
		verif(s3, 0, 64)	# verifica se o valor digitado pelo usuario eh valido
		
		print_str(txt_xf)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s5, a0		# Transfere o valor de a0 pro registrador s5
		
		verif(s5, 0, 64)	# verifica se o valor digitado pelo usuario eh valido
		
		print_str(txt_yi)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s4, a0		# Transfere o valor de a0 pro registrador s4
		
		verif(s4, 0, 64)	# verifica se o valor digitado pelo usuario eh valido
		
		print_str(txt_yf)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s6, a0		# Transfere o valor de a0 pro registrador s6
		
		verif(s7, 0, 64)	# verifica se o valor digitado pelo usuario eh valido
		
	.end_macro
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao rgb_color: recebe os valores de R, G e B digitados pelo usuario para definir a cor do pixel
	.macro rgb_color
		
		li t6, 256
		
		print_str(txt_val_r)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s7, a0		# Transfere o valor de a0 pro registrador s7
		
		verif(s7, 0, 256)	# verifica se o valor digitado pelo usuario eh valido
		
		# achando o valor referente ao R do pixel
		mul s7, s7, t6		# s7 = s7 * 256
		mul s7, s7, t6		# s7 = s7 * 256
		
		print_str(txt_val_g)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s8, a0		# Transfere o valor de a0 pro registrador s8
		
		verif(s8, 0, 256)	# verifica se o valor digitado pelo usuario eh valido
		
		# achando o valor referente ao G do pixel
		mul s8, s8, t6		# s8 = s8 * 256
		
		print_str(txt_val_b)	# atribui a string .asciz txt_x a funcao print_str para printar os caracteres na tela
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv s9, a0		# Transfere o valor de a0 pro registrador s9
		
		verif(s9, 0, 256)	# verifica se o valor digitado pelo usuario eh valido
		
		add t0, s7, s8		# Soma os valores digitado pelo usuario --> t0 = R + G
		add t0, t0, s9		# Soma os valores digitado pelo usuario --> t0 = t0 + B
		
	.end_macro
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao menu: criado para chamar o menu usando o beq, pois não estava funcionando chamar o macro direto
	menu:
		print_str(txt_menu)	# atribui a string .asciz txt_menu a funcao print_str para printar o texto com as opcoes do menu na tela
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao read_int: ler um valor inteiro digitado pelo usuario
	read_int:
		# chamada de sistema para ler numero inteiro -> definida por a7=5 
		# parametros: nao ha¡
		# retorno: a0 recebe o numero inteiro digitado
		li a7, 5		# a7=5 -> definicao da chamada de sistema para ler numero inteiro
		ecall			# realiza a chamada de sistema
		mv a4, a0		# Transfere o valor de a0 pro registrador a4
		
		verif(a4, 1, 9)		# verifica se o valor digitado pelo usuario eh valido
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Verifica se o usuario digitou o numero 8, se sim jump para a label exit
	li t3, 8
	beq a4, t3, exit 		
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Verifica se o usuario digitou um numero >= 5 , se sim jump para a label params_load.
	# Verificamos se eh maior ou igual a 5 pois as funcoes 5, 6 e 7 necessitam abrir a imagem e carrega-la no display, com isso, precisam usar as funcoes: 
	# params_load e load, e como já foi verificado se o usuario digitou o valor 8 que indica se o usuario deseja encerrar o programa essa verificacao eh valida.
	li t3, 5 
	bge a4, t3, params_load		
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Caso nenhuma das expressões beq e bge acima sejam verdadeiras eh feito o jump para a label go_to que direciona qual função deve ser executada
	j go_to				
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao params_load: define os parametros necessarios aos registradores
	# Parametros:
	#  a0: recebe o nome da imagem a ser carregada
	#  a1: recebe o endereço inicial do display bmp
	#  a2: recebe o endereço de buffer para onde a imagem sera carregada
	#  a3: recebe a qtd total de pixels da imagem
	params_load:
		la a0, image_name
		lw a1, address
		la a2, buffer
		lw a3, size
		jal load
  	
  		# definicao da chamada de sistema para encerrar programa, caso não funcione o jump para a label load	
		# parametros da chamada de sistema: a7 = 10
		li a7, 10		
		ecall
  	# ------------------------------------------------------------------------
  	
  	# ------------------------------------------------------------------------
  	# Funcao load: abre o arquivo e carrega a imagem no buffer
  	load:
		# salva os parametros da funcao nos registradores temporarios
		mv t0, a0		# nome do arquivo
		mv t1, a1		# endereco de carga
		mv t2, a2		# buffer para leitura de um pixel do arquivo
		
		# chamada de sistema para abertura de arquivo
		# parametros da chamada de sistema: a7 = 1024, a0 = string com o diretorio da imagem, a1 = definicao de leitura/escrita		
		li a7, 1024		# chamada de sistema para abertura de arquivo
		li a1, 0		# Abre arquivo para leitura (pode ser 0: leitura, 1: escrita)
		ecall			# Abre um arquivo (descritor do arquivo eh retornado em a0)
		mv s6, a0		# salva o descritor do arquivo em s6
	
		mv a0, s6		# descritor do arquivo 
		mv a1, t2		# endereco do buffer 
		li a2, 3		# largura do buffer
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao go_to: indica de acordo com a entrada do usuario qual função deve ser executada
	go_to:
		li t3, 1
		beq a4, t3, get_point			# Verifica se o usuario digitou o numero 1, se sim jump para a label get_point 
		
		li t3, 2
		beq a4, t3, draw_point			# Verifica se o usuario digitou o numero 2, se sim jump para a label draw_point 
		
		li t3, 3
		beq a4, t3, draw_full_rectangle		# Verifica se o usuario digitou o numero 3, se sim jump para a label draw_point
		
		li t3, 4
		beq a4, t3, draw_empty_rectangle	# Verifica se o usuario digitou o numero 4, se sim jump para a label draw_point		
		
		li t3, 5
		beq a4, t3, convert_negative		# Verifica se o usuario digitou o numero 5, se sim jump para a label convert_negative 
		
		li t3, 6
		beq a4, t3, convert_redtones		# Verifica se o usuario digitou o numero 6, se sim jump para a label convert_redtones
		
		li t3, 7
		beq a4, t3, load_img			# Verifica se o usuario digitou o numero 7, se sim jump para a label load_img
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao load_image: carrega uma imagem em formato RAW RGB para memoria
	# Formato RAW: sequencia de pixels no formato RGB, 8 bits por componente
	# de cor, R o byte mais significativo
	#
	# Parametros:
	#  a0: endereco do string ".asciz" com o nome do arquivo com a imagem
	#  a1: endereco de memoria para onde a imagem sera carregada
	#  a2: endereco de uma palavra na memoria para utilizar como buffer
	#  a3: tamanho da imagem em pixels
				
	# load_img utiliza um jump para realizar um loop para ler pixel a pixel da imagem
	load_img:  
		beq a3, zero, close		# verifica se o contador de pixels da imagem chegou a 0
		
		# chamada de sistema para leitura de arquivo
		# parametros da chamada de sistema: a7=63, a0=descritor do arquivo, a1 = endereco do buffer, a2 = maximo tamanho pra ler
		
		li a7, 63			# definico da chamada de sistema para leitura de arquivo 
		ecall            		# le o arquivo
		lw   t4, 0(a1)   		# le pixel do buffer	
		sw   t4, 0(t1)   		# escreve pixel no display
		addi t1, t1, 4  		# proximo pixel
		addi a3, a3, -1  		# decrementa countador de pixels da imagem
		
		j load_img			# jump para realizar o loop enquanto o contador de pixels nao for igual a 0		
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------	
	# Funcao convert_redtones: deixar a imagem em tons avermelhados, é possivel fazer isso zerando os valores referentes ao G e B do pixel
	convert_redtones:
				
		beq a3, zero, close		# verifica se o contador de pixels da imagem chegou a 0
		
		# chamada de sistema para leitura de arquivo
		# parametros da chamada de sistema: a7=63, a0=descritor do arquivo, a1 = endereco do buffer, a2 = maximo tamanho pra ler
		
		li a7, 63			# definico da chamada de sistema para leitura de arquivo 
		ecall            		# le o arquivo
		lw   t4, 0(a1)   		# le pixel do buffer
		li t5, 0x00ff0000		# Atribui o hexadecimal da cor vermelha ao t5
		and t6, t5, t4 			# Faz um and bit a bit com o intuito de zerar os bits correspondentes ao G e B
		sw   t6, 0(t1)   		# escreve pixel no display
		addi t1, t1, 4  		# proximo pixel
		addi a3, a3, -1  		# decrementa countador de pixels da imagem
		
		j convert_redtones		# jump para realizar o loop enquanto o contador de pixels nao for igual a 0
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------	
	# Funcao convert_negative: deixar a imagem em tons negativos, é possivel fazer isso pegando 255 e subtrair dele o valor de cada pixel			
	convert_negative:
				
		beq a3, zero, close		# verifica se o contador de pixels da imagem chegou a 0
		
		# chamada de sistema para leitura de arquivo
		# parametros da chamada de sistema: a7=63, a0=descritor do arquivo, a1 = endereco do buffer, a2 = maximo tamanho pra ler
		
		li a7, 63			# definicao da chamada de sistema para leitura de arquivo 
		ecall            		# le o arquivo
		lw   t4, 0(a1)   		# le pixel do buffer
		li t5, 255 			# Atribui o valor 255 ao t5 
		sub t6, t5, t4 			# t6 = t5 - t4 --> t6 = 255(que é transformado pra hexa pelo rars) - (hexadecimal do pixel atual)
		sw   t6, 0(t1)   		# escreve pixel no display
		addi t1, t1, 4  		# proximo pixel
		addi a3, a3, -1  		# decrementa countador de pixels da imagem
		
		j convert_negative		# jump para realizar o loop enquanto o contador de pixels nao for igual a 0
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------	
	# Funcao get_point: pega os valores RGB do pixel na posicao x e y digitada pelo usuario 
	# Parametros:
	#   s3: registrador que contem o valor digitado pelo usuario referente a variavel x
	#   s4: registrador que contem o valor digitado pelo usuario referente a variavel y
	get_point:
		
		val_x_y				# chama a funcao que imprime na tela pedindo ao usuario para digitar os valores de x e y
		
	  	li t4, 0x10043f00 		# t4 = posicao x = 0 y = 0  	
	  	li s1, -256			# atribui o valor -256 ao registrador s1
		li s2, 4			# atriui o valor 4 ao registrador s2
		
		mul s3, s3, s2 			# x = x * 4
		mul s4, s4, s1 			# y = y * (-256) 
			
		add t5, s4, s3 			# t5 = -256y + 4x
		
		add t4, t4, t5 			# t4 = t4 + t5
		
		lw t6, 0(t4)			# atribui o valor do RGB pixel para o registrador temporario t6
		
		print_str(txt_rgb)		# imiprime na tela "Valor RGB do ponto desejado: "
		
		li  a7, 34			# atribui o valor 34 ao registrado a7, que corresponde a impressao de um numero em hexadecimal
    		add a0, t6, zero		# carrega o valor no registrador a0
    		ecall				# chamada de sistena para printar o valor na tela
    		
    		print_str(txt_space_line) 	# insere uma quebra de linha na tela
    		
    		j menu				# volta para o menu
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao draw_point: desenha no display na posicao x e y desejada pelo usuario
	# Parametros:
	#   s3: registrador que contem o valor digitado pelo usuario referente a variavel x
	#   s4: registrador que contem o valor digitado pelo usuario referente a variavel y
	draw_point:
		
		val_x_y			# chama a funcao que imprime na tela pedindo ao usuario para digitar os valores de x e y
		rgb_color		# chama a funcao que recebe os valores R, G e B para defeinir a cor dos pixels a serem desnhados
		
	  	li t4, 0x10043f00 	# t4 = posicao x = 0 y = 0  	
	  	li s1, -256		# atribui o valor -256 ao registrador s1
		li s2, 4		# atriui o valor 4 ao registrador s2

		mul s3, s3, s2 		# x = x * 4
		mul s4, s4, s1		# y = y * (-256) 
			
		add t5, s4, s3 		# t5 = -256y + 4x
		
		add t4, t4, t5 		# t4 = t4 + t5
		
		#li t0, 0x00ff0000	 valor da cor vermelha que sera utilizada para desenhar na tela
		sw t0, 0(t4) 		# desenha no display na posicao desejada	
		
		j menu			# volta para o menu
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao draw_full_rectangle: desenha no display um retangulo com fundo usando os pontos digitados pelo usuario
	# Parametros:
	#   s3: registrador que recebe o valor referente ao x inicial digitado pelo usuario
	#   s4:	registrador que recebe o valor referente ao y inicial digitado pelo usuario
	#   s5: registrador que recebe o valor referente ao x final digitado pelo usuario
	#   s6: registrador que recebe o valor referente ao y final digitado pelo usuario
	draw_full_rectangle:
		
		val_xi_yi_xf_yf			# chama a funcao que imprime na tela pedindo ao usuario para digitar os valores de x e y inicial e final
		rgb_color			# chama a funcao que recebe os valores R, G e B para defeinir a cor dos pixels a serem desnhados
		
		lw t1, init 			# posicao 0x0 do bitmap
		
		li a3, 4096 			# quantidade de pixels do display
		li s1, -256 			# quantidade de pixels para andar em y
		li s2, 4 			# quantidade de pixels para andar em x
		
		mv a4, s5			# atribui o valor de x final a a4
		mv a6, s6			# atribui o valor de y final a a6
				
		# Funcao acha_posicao_full: encontra a posicao inicial do desenho
		acha_posicao_full:	
	  		mv t3, t1 		# t3 = posicao 0x0
			
			mul s3, s3, s2 		# x = x * 4
			mul s4, s4, s1 		# y = y * (-256) 
			
			add t5, s4, s3 		# t5 = -256y + 4x
			
			add t3, t3, t5 		# t3 = t3 + t5
			
			mv t6, t3 		# t6 armazena a posicao de inicio do desenho			
			
		# Funcao draw_x1_full: vai preenchendo em x da esquerda pra direita
		draw_x1_full:
			beq s5, zero, draw_y1_full	# se s5 (largura do retangulo) chegar a 0, o programa vai para draw_y1_full
			
			sw t0, 0(t6)			# desenha um ponto
			addi s5, s5, -1			# decrementa s5 
			addi t6, t6, 4			# passa para a posicao do proximo pixel
			
			j draw_x1_full			# repete draw_x1_full
			
		# Funcao draw_y1_full: sobe uma posicao em y
		draw_y1_full:
			addi t6, t6, -4			# volta uma posicao em t6
			mv s5, a4			# atribui o valor digitado pelo usuario corresponde ao x final a s5
			
			beq s6, zero, menu		# se s6 (altura do retangulo) chegar a 0, o programa volta para o menu
			
			addi t6, t6, -256		# leva t6 para a posicao do pixel acima
			addi s6, s6, -1			# decrementa a altura do retangulo
			
			j draw_x2_full			# pula para draw_x2_full
			
			
		# Funcao draw_x2_full: vai preenchendo em x da direita pra esquerda
		draw_x2_full:
			beq s5, zero, draw_y2_full	# se s5 (largura do retangulo) chegar a 0, o programa vai para draw_y2_full
			
			sw t0, 0(t6)			# desenha um ponto
			addi s5, s5, -1			# decrementa s5 
			addi t6, t6, -4			# passa para a posicao do proximo pixel
			
			j draw_x2_full			# repete draw_x2_full
			
		# Funcao draw_y2_full: mesma funcionalidade do draw_y1_full, so que com um jump para o draw_x1_full
		draw_y2_full:
			addi t6, t6, 4			# volta uma posicao em t6
			mv s5, a4			# atribui o valor digitado pelo usuario corresponde ao x final a s5
			
			beq s6, zero, menu		# se s6 (altura do retangulo) chegar a 0, o programa volta para o menu
			
			addi t6, t6, -256		# leva t6 para a posicao do pixel acima
			addi s6, s6, -1			# decrementa a altura do retangulo
			
			j draw_x1_full			# pula para draw_x1_full
			
		j menu					# volta para o menu			
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao draw_empty_rectangle: desenha no display um retangulo sem fundo usando os pontos digitados pelo usuario
	# Parametros:
	#   s3: registrador que recebe o valor referente ao x inicial digitado pelo usuario
	#   s4:	registrador que recebe o valor referente ao y inicial digitado pelo usuario
	#   s5: registrador que recebe o valor referente ao x final digitado pelo usuario
	#   s6: registrador que recebe o valor referente ao y final digitado pelo usuario
	draw_empty_rectangle:
		
		val_xi_yi_xf_yf			# chama a funcao que imprime na tela pedindo ao usuario para digitar os valores de x e y inicial e final
		rgb_color			# chama a funcao que recebe os valores R, G e B para defeinir a cor dos pixels a serem desnhados
		
		lw t1, init 			# posicao 0x0 do bitmap
		
		li a3, 4096 			# quantidade de pixels do display
		li s1, -256 			# quantidade de pixels para andar em y
		li s2, 4 			# quantidade de pixels para andar em x 
		
		mv a4, s5			# atribui o valor de x final a a4
		mv a6, s6			# atribui o valor de y final a a6
		
		# Funcao acha_posicao_empty: encontra a posicao inicial do desenho
		acha_posicao_empty:	
	  		mv t3, t1 		# t3 = posicao 0x0
			
			mul s3, s3, s2 		# x = x * 4
			mul s4, s4, s1 		# y = y * (-256) 
			
			add t5, s4, s3 		# t5 = -256y + 4x
			
			add t3, t3, t5 		# t3 = t3 + t5
			
			mv t6, t3 		# t6 armazena a posicao de inicio do desenho	
			
		# Funcao draw_x1_empty: vai preenchendo em x da esquerda pra direita
		draw_x1_empty:
			beq s5, zero, draw_y1_empty		# se s5 (largura do retangulo) chegar a 0, o programa pula para draw_y1_empty
			
			sw t0, 0(t6)				# desenha um pixel na posicao atual
			addi s5, s5, -1				# decrementa s5
			addi t6, t6, 4				# incrementa a posicao do pixel
			
			j draw_x1_empty				# repete draw_x1_empty
			
		# Funcao draw_y1_empty: vai preenchendo em y de baixo pra cima
		draw_y1_empty:
			mv s5, a4			# atribui o valor digitado pelo usuario corresponde ao x final a s5
			beq s6, zero, draw_x2_empty	# se s6 (altura do retangulo) chegar a zero, o programa pula para draw_x2_empty
			
			sw t0, 0(t6)			# desenha um pixel na posicao atual
			addi s6, s6, -1			# decrementa s6
			addi t6, t6, -256		# pula para a posicao do pixel de cima
			
			j draw_y1_empty			# repete draw_y1_empty
			
		# Funcao draw_x2_empty: vai preenchendo em x da direita pra esquerda
		draw_x2_empty:
			mv s6, a6			# atribui o valor digitado pelo usuario corresponde ao y final a s6
			beq s5, zero, draw_y2_empty	# se s5 (largura do retangulo) chegar a 0, o programa pula para draw_y2_empty
			
			sw t0, 0(t6)			# desenha um pixel na posicao atual
			addi s5, s5, -1			# decrementa s5
			addi t6, t6, -4			# pula para a proxima posicao
			
			j draw_x2_empty			# repete draw_x2_empty
			
		# Funcao draw_y2_empty: vai preenchendo em y de cima pra baixo
		draw_y2_empty:
			beq s6, zero, menu		# se s6 (altura do retangulo) chegar a 0, a funcao termina e o programa pula para o menu
			
			sw t0, 0(t6)			# desenha um pixel na posicao atual
			addi s6, s6, -1			# decrementa s6
			addi t6, t6, 256		# pula para a posicao do pixel debaixo
			
			j draw_y2_empty			# repete draw_y2_empty
			
		j menu					# volta para o menu
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------										
	# Funcao close: fecha o arquivo 
	close:
		# chamada de sistema para fechamento do arquivo
		# parametros da chamada de sistema: a7=57, a0=descritor do arquivo
		
		li a7, 57		# chamada de sistema para fechamento do arquivo
		mv a0, s6		# descritor do arquivo a ser fechado
		ecall          		# fecha arquivo
		
		j menu 			# volta pro menu
	# ------------------------------------------------------------------------
	
	# ------------------------------------------------------------------------
	# Funcao exit: encerrar o programa	
	exit:
		# definicao da chamada de sistema para encerrar programa	
		# parametros da chamada de sistema: a7=10
		li a7, 10		
		ecall
	# ------------------------------------------------------------------------
