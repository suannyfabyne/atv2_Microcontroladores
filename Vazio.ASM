;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     SEMAFORO (ATIVIDADE2)                       *
;*                 SUANNY FABYNE DA SILVA VIEIRA                   *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 26/07/2018        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*   ATIVIDADE 2 DA DISCIPLINA DE MICROCONTROLADORES               *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS
		CONT ;ESSE É O CONTADOR A SER EXIBIDO NO DISPLAY
		AUX ;ESSA VARIAVEL É AUXILIAR DE CONT, ELA RECEBE O VALOR DE COUNT E REALIZA O SHIFT
		VARDELAY1 ;VARIAVEL AUXILIAR PARA CONSTRUÇAO DO MEU DELAY
		VARDELAY2 ;SEGUNDA VARIAVEL AUXILIAR PARA CONSTRUÇAO DO MEU DELAY

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

DESVIO
	
	
	

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	MOVLW B'1010' ;INICIALIZANDO VARIAVEL COM 10, PARA SER DECREMENTADA E COLOCADA NO DISPLAY COMO 9 
	MOVWF CONT
	BCF GPIO, GP0 ;MUDANDO INICIALMENTE O SINAL PARA 0
DECREMENTA ;AQUI ENTRA NO LAÇO DECREMENTO
	MOVLW .255
	MOVWF VARDELAY1 ;INICANDO UM CONTADOR COM VALOR MAXIMO, AFIM DE AJUSTAR MEU DELAY PARA 300MS
	MOVLW .235 
	MOVWF VARDELAY2 ;INICANDO UM CONTADOR COM VALOR TESTADO, AFIM DE AJUSTAR MEU DELAY PARA 300MS
	GOTO DELAY ;APLICA O DELAY
CABOUDELAY ;QUANDO ACABA O DELAY, VOLTA PARA CÁ
	DECF CONT, F ;DECREMENTA O CONTADOR E COLOCA O VALOR EM F
	MOVFW CONT 
	MOVWF AUX ;MOVE O VALOR DO W (QUE RECEBE O VALOR DE CONT) PARA UMA VARIAVEL AUXILIAR, AFIM DE OPERAR NO DISPLAY 
	GOTO DISPLAY ;VAI PARA DISPLAY
JAMOSTREI ;QUANDO EXIBIR O VALOR REQUERIDO NO DISPLAY, VOLTA PARA CÁ
	BTFSS STATUS, Z ;CHEGA SE O CONTADOR ESTÁ EM 0, SE SIM O Z É SETADO
	GOTO DECREMENTA ;SE O CONTADOR AINDA FOR > 0, VOLTA PARA A LABEL DECREMENTA 
	BSF GPIO, GP0 ;SE O CONTADOR CHEGAR EM 0, SETA O GP0, MUDANDO O ESTADO DO SINAL (DE VERMELHO VAI PARA VERDE)
	MOVLW B'1010' 
	MOVWF CONT ;ENFIM SETADO O A PORTA QUE REPRESENTA O SINAL, REINICIA O CONTADOR 
DECREMENTA2 ;NAS PROXIMAS INSTRUÇOES, REPETE TODO O PROCESSO DE CONFIGURAR VARIAVEL DO DELAY, DECREMENTO E EXIBIÇÃO NO DISPLAY
	MOVLW .255 
	MOVWF VARDELAY1 ;PRECISAMOS REINICIAR O VALOR DO DELAY NOVAMENTE, PARA AGIR CORRETAMENTE, POIS ELE FOI DECREMENTADO
	MOVLW .235
	MOVWF VARDELAY2
	GOTO DELAY
CABOUDELAY2 ;DEPOIS DO DELAY, VEM PARA CÁ
	DECF CONT, F ;DECREMENTA CONTADOR, COMO JA DITO ANTES, REPETINDO O PROCESSO 
	MOVFW CONT
	MOVWF AUX
	GOTO DISPLAY 
JAMOSTREI2
	BTFSS STATUS, Z ;CHECA SE O CONTADOR JÁ CHEGOU A 0
	GOTO DECREMENTA2
	GOTO MAIN ;VOLTA PARA O INICIO DO PROGRAMA, ONDE A PORTA QUE REPRESENTA O SEMAFORO SERÁ ZERADA E INICIA O PROCESSO NOVAMENTE
DISPLAY ;AQUI ENTRA NA PARTE DO DISPLAY
	BTFSS AUX, 0 ;É CHECADO O BIT MENOS SIGNIFICATIVO DA VARIAVEL AUX, QUE CONTEM O VALOR DO CONTADOR
	GOTO ZERA1 ;SE O BIT MENOS SIGNIFICATIVO FOR 0, DESVIA
	BSF GPIO, GP1 ;SE FOR 1, É SETADA A PORTA 1
VOLTA1
	RRF AUX ;AGORA, FAZEMOS UM SHIFT PARA DIREITA, AFIM DE OBTER O PROXIMO BIT MENOS SIGNICATIVO, E CHECA-LO
	BTFSS AUX, 0 ;CHECAMOS O PROXIMO BIT, DEPOIS DE FAZER O DESLOCAMENTO
	GOTO ZERA2
	BSF GPIO, GP2 ;SE 1, SETA
VOLTA2	
	RRF AUX ;REPETE O MESMO PROCESSO DE DESLOCAMENTO E CHECA O BIT
	BTFSS AUX, 0
	GOTO ZERA4
	BSF GPIO, GP4
VOLTA4	
	RRF AUX ;REPETE O MESMO PROCESSO DE DESLOCAMENTO E CHECA O BIT
	BTFSS AUX, 0
	GOTO ZERA5
	BSF GPIO, GP5 ;SETA A ULTIMA PORTA
VOLTA5
	BTFSS GPIO, GP0 ;CONFERE SE O GP0 ESTÁ 0 OU 1, SE TIVER 0, VOLTA PARA UMA LABEL ESPECIFICA, SE NAO, VOLTA PARA OUTRA LABEL, ASSIM PARA FAZER O FLUXO CORRETAMENTE DO PROGRAMA
	GOTO JAMOSTREI ;VOLTA PARA A LABEL DE QUANDO O GP0 ESTÁ 0
	GOTO JAMOSTREI2 ;VOLTA PARA A LABEL DE QUANDO O GP0 ESTÁ 1
	
ZERA1
	BCF GPIO, GP1 ;MUDA O VALOR DA PORTA PARA 0
	GOTO VOLTA1 ;VOLTA PARA A LABEL DISPLAY, PARA VOLTAR AO FLUXO NORMAL
ZERA2 
	BCF GPIO, GP2 ;MUDA O VALOR DA PORTA PARA 0
	GOTO VOLTA2 ;VOLTA PARA A LABEL DISPLAY, PARA VOLTAR AO FLUXO NORMAL
ZERA4 
	BCF GPIO, GP4 ;MUDA O VALOR DA PORTA PARA 0
	GOTO VOLTA4 ;VOLTA PARA A LABEL DISPLAY, PARA VOLTAR AO FLUXO NORMAL
ZERA5 
	BCF GPIO, GP5 ;MUDA O VALOR DA PORTA PARA 0
	GOTO VOLTA5 ;VOLTA PARA A LABEL DISPLAY, PARA VOLTAR AO FLUXO NORMAL
DELAY ;LABEL PARA CONSTRUÇAO DO DELAY: FUNCIONA COMO UM ANINHAMENTO DE LAÇOS
	NOP ; É COLOCADO DOIS NOP PARA AJUSTAR O TEMPO (300MS) CORRETAMENTE
	NOP
	DECFSZ VARDELAY1 ;DECREMENTA A VARIAVEL QUE POSSUI O VALOR DE 255 (MAXIMO POSSIVEL) E CHECA SE FOR 0
	GOTO DELAY ;SEMPRE QUE DECREMENTAR, VOLTA PRO DELAY, ONDE GASTA TEMPO COM OS NOP E DECREMENTANDO MAIS UMA VEZ O VARDELAY1 ATÉ QUE SEJA 0
	DECFSZ VARDELAY2 ;DECREMENTA A VARIAVEL E CHECA SE FOR 0
	GOTO DELAY2 ;VAI PARA O SEGUNDO LAÇO AUXLIAR DO DELAY ENQUANTO O VARDELAY2 FOR > 0
	BTFSS GPIO, GP0 ;TESTAMOS O VALOR DO GP0 PARA REDIRECIONAR PARA A LABEL CORRETA (DEPENDE SE FOR 0 OU 1) E MANTER O FLUXO DO PROGRAMA CORRETAMENTE
	GOTO CABOUDELAY ;VAI PARA A LABEL DE QUANDO GP0 = 0
	GOTO CABOUDELAY2 ;VAI PARA A LABEL DE QUANDO GP0 = 1
DELAY2
	MOVLW .255 ;COMO O VARDELAY FOI ZERADA ACIMA, INICIAMOS O VALOR DELA DE NOVO, PARA QUE SEJA INICIADA E DECREMENTADA (VARDELAY2 = 235) VEZES, E FORME UMA REPETIÇAO
	MOVWF VARDELAY1 
	GOTO DELAY ;VOLTA PARA O INICIO DO DELAY
	

	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
