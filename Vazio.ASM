;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     SEMAFORO (ATIVIDADE2)                       *
;*                 SUANNY FABYNE DA SILVA VIEIRA                   *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 26/07/2018        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*   ATIVIDADE 2 DA DISCIPLINA DE MICROCONTROLADORES               *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES

		;NOVAS VARI�VEIS
		CONT ;ESSE � O CONTADOR A SER EXIBIDO NO DISPLAY
		AUX ;ESSA VARIAVEL � AUXILIAR DE CONT, ELA RECEBE O VALOR DE COUNT E REALIZA O SHIFT
		VARDELAY1 ;VARIAVEL AUXILIAR PARA CONSTRU�AO DO MEU DELAY
		VARDELAY2 ;SEGUNDA VARIAVEL AUXILIAR PARA CONSTRU�AO DO MEU DELAY

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

DESVIO
	
	
	

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	MOVLW B'1010' ;INICIALIZANDO VARIAVEL COM 10, PARA SER DECREMENTADA E COLOCADA NO DISPLAY COMO 9 
	MOVWF CONT
	BCF GPIO, GP0 ;MUDANDO INICIALMENTE O SINAL PARA 0
DECREMENTA ;AQUI ENTRA NO LA�O DECREMENTO
	MOVLW .255
	MOVWF VARDELAY1 ;INICANDO UM CONTADOR COM VALOR MAXIMO, AFIM DE AJUSTAR MEU DELAY PARA 300MS
	MOVLW .235 
	MOVWF VARDELAY2 ;INICANDO UM CONTADOR COM VALOR TESTADO, AFIM DE AJUSTAR MEU DELAY PARA 300MS
	GOTO DELAY ;APLICA O DELAY
CABOUDELAY ;QUANDO ACABA O DELAY, VOLTA PARA C�
	DECF CONT, F ;DECREMENTA O CONTADOR E COLOCA O VALOR EM F
	MOVFW CONT 
	MOVWF AUX ;MOVE O VALOR DO W (QUE RECEBE O VALOR DE CONT) PARA UMA VARIAVEL AUXILIAR, AFIM DE OPERAR NO DISPLAY 
	GOTO DISPLAY ;VAI PARA DISPLAY
JAMOSTREI ;QUANDO EXIBIR O VALOR REQUERIDO NO DISPLAY, VOLTA PARA C�
	BTFSS STATUS, Z ;CHEGA SE O CONTADOR EST� EM 0, SE SIM O Z � SETADO
	GOTO DECREMENTA ;SE O CONTADOR AINDA FOR > 0, VOLTA PARA A LABEL DECREMENTA 
	BSF GPIO, GP0 ;SE O CONTADOR CHEGAR EM 0, SETA O GP0, MUDANDO O ESTADO DO SINAL (DE VERMELHO VAI PARA VERDE)
	MOVLW B'1010' 
	MOVWF CONT ;ENFIM SETADO O A PORTA QUE REPRESENTA O SINAL, REINICIA O CONTADOR 
DECREMENTA2 ;NAS PROXIMAS INSTRU�OES, REPETE TODO O PROCESSO DE CONFIGURAR VARIAVEL DO DELAY, DECREMENTO E EXIBI��O NO DISPLAY
	MOVLW .255 
	MOVWF VARDELAY1 ;PRECISAMOS REINICIAR O VALOR DO DELAY NOVAMENTE, PARA AGIR CORRETAMENTE, POIS ELE FOI DECREMENTADO
	MOVLW .235
	MOVWF VARDELAY2
	GOTO DELAY
CABOUDELAY2 ;DEPOIS DO DELAY, VEM PARA C�
	DECF CONT, F ;DECREMENTA CONTADOR, COMO JA DITO ANTES, REPETINDO O PROCESSO 
	MOVFW CONT
	MOVWF AUX
	GOTO DISPLAY 
JAMOSTREI2
	BTFSS STATUS, Z ;CHECA SE O CONTADOR J� CHEGOU A 0
	GOTO DECREMENTA2
	GOTO MAIN ;VOLTA PARA O INICIO DO PROGRAMA, ONDE A PORTA QUE REPRESENTA O SEMAFORO SER� ZERADA E INICIA O PROCESSO NOVAMENTE
DISPLAY ;AQUI ENTRA NA PARTE DO DISPLAY
	BTFSS AUX, 0 ;� CHECADO O BIT MENOS SIGNIFICATIVO DA VARIAVEL AUX, QUE CONTEM O VALOR DO CONTADOR
	GOTO ZERA1 ;SE O BIT MENOS SIGNIFICATIVO FOR 0, DESVIA
	BSF GPIO, GP1 ;SE FOR 1, � SETADA A PORTA 1
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
	BTFSS GPIO, GP0 ;CONFERE SE O GP0 EST� 0 OU 1, SE TIVER 0, VOLTA PARA UMA LABEL ESPECIFICA, SE NAO, VOLTA PARA OUTRA LABEL, ASSIM PARA FAZER O FLUXO CORRETAMENTE DO PROGRAMA
	GOTO JAMOSTREI ;VOLTA PARA A LABEL DE QUANDO O GP0 EST� 0
	GOTO JAMOSTREI2 ;VOLTA PARA A LABEL DE QUANDO O GP0 EST� 1
	
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
DELAY ;LABEL PARA CONSTRU�AO DO DELAY: FUNCIONA COMO UM ANINHAMENTO DE LA�OS
	NOP ; � COLOCADO DOIS NOP PARA AJUSTAR O TEMPO (300MS) CORRETAMENTE
	NOP
	DECFSZ VARDELAY1 ;DECREMENTA A VARIAVEL QUE POSSUI O VALOR DE 255 (MAXIMO POSSIVEL) E CHECA SE FOR 0
	GOTO DELAY ;SEMPRE QUE DECREMENTAR, VOLTA PRO DELAY, ONDE GASTA TEMPO COM OS NOP E DECREMENTANDO MAIS UMA VEZ O VARDELAY1 AT� QUE SEJA 0
	DECFSZ VARDELAY2 ;DECREMENTA A VARIAVEL E CHECA SE FOR 0
	GOTO DELAY2 ;VAI PARA O SEGUNDO LA�O AUXLIAR DO DELAY ENQUANTO O VARDELAY2 FOR > 0
	BTFSS GPIO, GP0 ;TESTAMOS O VALOR DO GP0 PARA REDIRECIONAR PARA A LABEL CORRETA (DEPENDE SE FOR 0 OU 1) E MANTER O FLUXO DO PROGRAMA CORRETAMENTE
	GOTO CABOUDELAY ;VAI PARA A LABEL DE QUANDO GP0 = 0
	GOTO CABOUDELAY2 ;VAI PARA A LABEL DE QUANDO GP0 = 1
DELAY2
	MOVLW .255 ;COMO O VARDELAY FOI ZERADA ACIMA, INICIAMOS O VALOR DELA DE NOVO, PARA QUE SEJA INICIADA E DECREMENTADA (VARDELAY2 = 235) VEZES, E FORME UMA REPETI�AO
	MOVWF VARDELAY1 
	GOTO DELAY ;VOLTA PARA O INICIO DO DELAY
	

	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
