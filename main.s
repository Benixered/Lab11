.data
.align 2
@Message strings
mensajeBienvenida: .asciz "Bienvenido\n"
mensajeEmpate: .asciz "Empate\n"
mensajeGanador: .asciz "GANADOR: Jugador %d!\n"
.text
.align 2
.global main
.type main,%function

main:
	stmfd sp!, {lr}

	ganador .req r5
	cont .req r6
	mov cont, #0
	mov winner, #0

	ldr r0, =mensajeBienvenida
	bl printf
	mov r0, #0

	ldr r0, =emptyInputMessage
	bl printf

Jugadoruno:
	mov r1, #0
	mov r0, #1
	bl input

	@Obtener Inputs y insertar
	mov r1, r0		@Columna
	mov r0, #1		@Jugador
	bl insertInput
	
	
	bl printBoard
	
	@puedeganar
	bl getWinner	 @Subroutine on Game Script (game.s)  	
	mov winner, r0
	cmp winner, #0
	bne printWinner

Jugadordos:
	mov r1, #0
	mov r0, #2
	bl input
	
	@Obtener inputs y insertar
	mov r1, r0		@Columna 
	mov r0, #2		@Jugador
	bl insertInput

	
	bl printBoard
	
	@puedeganar
	bl getWinner			@Subroutine on Game Script (game.s)  		
	mov winner, r0
	cmp winner, #0	@If there's a tie
	bne printWinner

	add cont, #1
	b verifyTie

verifyTie:
	cmp cont, #8	
	bne playerOneInput
	beq printTie

printTie:
	ldr r0, =tieMessage
	bl printf


printWinner:
	ldr r0, =winnerMessage
	mov r1, winner
	bl printf 

exit:
	@unlink variables
	.unreq winner
	.unreq cont
	@OS exit
	mov r0,#0
	mov r3,#0

	ldmfd sp!,{lr}
	bx lr