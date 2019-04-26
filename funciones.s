/***********************************************
Roberto Castillo 18546
Benjamin Izquierdo
Luis perez Aju
***********************************************/
.data
.align 2

@Se crea la matriz con la que se trabajará 
col1: .word 0,0,0,0
col2: .word 0,0,0,0
col3: .word 0,0,0,0
col4: .word 0,0,0,0

@Columna Deseada
ColumnaActual: .word 0

colIngresada: .asciz "%d"
filas: .asciz "|%d|"
entrar: .asciz "\n"

ColumnaLlena: .asciz "--- La columna esta llena! ---\n"
error: .asciz "--- Valor erroneo, intentar de nuevo ---\n"
inputCol: .asciz "Ingrese la columna deseada %d (1, 2, 3, 4): \n"



.text
.align 2

/*******************************
		Entradas del jugador
*******************************/

.global input
input:
 	jugador .req r5
 	col .req r6
 	push {lr} @Se guarda el link register
 	mov jugador, r0 @se mueven los parametros a la variable jugador

inputgen:
	ldr r0, =inputCol @carga el mensaje de entrada
	mov r1, jugador @carga el jugador
	bl printf @muestra el mensaje
	ldr r0, =columnEntered @carga el formato de entrada
	ldr r1, =ColumnaActual @carga la direccion de entrada
	bl scanf 
	ldr r0, =ColumnaActual @carga el input en la columna actual
	ldr col, [r0] @carga el valor de entrada asignado
	cmp col, #1 @if(column < 1)
	blt EInput
	cmp col, #4 @else if(column > 4)
	bgt EInput
	ble InputTerminado

EInput:
	ldr r0, =error @carga el mensaje de error
	bl printf @muestra el mensaje de error
	b inputgen @de regreso a inputgen

InputTerminado:
	mov r0, col @mueve el valor de la columna al registro 0
	.unreq jugador @desconecta al jugador de la variable almacenada en r5
	.unreq col @desconecta a la columna de r6
	pop {lr} @recupera el lr
	mov pc, lr @Regresa a r0


/*******************************
		Insersiones del juego
*******************************/


.global insertInput
insInput:
	@variables 
	col .req r5
	box	   .req r6
	jugador .req r7
	cont  .req r8 
	@colInput .req r9

	push {lr} @almacena el lr
	mov jugador, r0 @almacena elvalor del jugador como parametro
	mov col, r1 @almacena la columna pasada como un parametro

	@Se hace un switch de la columna en r1
	cmp col, #1 
	ldreq col, =col1 
	cmp col, #2 
	ldreq col, =col2
	cmp col, #3 
	ldreq col, =col3
	cmp col, #4 
	ldreq col, =col4 
	@mov colInput, column @almacena la direccion de memoria de ingreso
	mov cont, #0

bucleV:
	ldr box, [col] @carga el elemento que este en la columna
	cmp box, #0 @if element is empty
	streq jugador, [col] @almacena aljugador en dicho elemento
	beq ultimainsersion @se mueve a la ultimainsersion
	add col, #4
	add cont, #1
	cmp cont, #4 @se hace el cmp por si esteno esigual a 4
	bne bucleV @se mueve al bucleV
	ldr r0, =ColumnaLlena @ si no se cumplen las condiciones, se muestra el mensje de columna llena
	bl printf @muestra el mensaje

ultimainsersion:
	@mov r0, columnInput @r0 = direccion del vector
	mov r0, column @r0 = direccion del vector
	@variables de los registros
	.unreq col
	.unreq box
	.unreq jugador
	.unreq cont
	@.unreq colInput
	pop {lr} @Retrieve the link register
	mov pc, lr @return r0

.global tabImpresion
tabImpresion:
    /*inefficient way of printing, improve this part later*/
	push {lr} @store the link register
	col1 .req r5 
	col2 .req r6 
	col3 .req r7 
	col4 .req r8 
	contCol .req r10	@Count, in this case, 4
    
	ldr col1, =col1
	ldr col2, =col2
	ldr col3, =col3
	ldr col4, =col4
    
	/*
	*	We always have to print matrix in reverse (down to up)
	*	cause player always put his answer on the top (up to down)
	*/

	add col1, #16
	add col2, #16
	add col3, #16
	add col4, #16
	mov contCol, #4

	bucCol:	@Imprimiendo all the rows

		sub col1, #4
		sub col2, #4
		sub col3, #4
		sub col4, #4
		@Printing
		ldr r0, =filaM
		ldr r1, [col1]
		bl printf
		ldr r0, =filaM
		ldr r1, [col2]
		bl printf
		ldr r0, =filaM
		ldr r1, [col3]
		bl printf
		ldr r0, =filaM
		ldr r1, [col4]
		bl printf
		ldr r0, =entrar
		bl printf

		subs contCol, #1	@contador
		bne bucCol	@si no es 0 regresa

	.unreq col1
	.unreq col2
	.unreq col3
	.unreq col4
	.unreq contCol

	pop {lr}
	mov pc, lr

/*******************************
		Verificar ganadores
		
*******************************/
/*
 * @param nada, @return: Ganador en r0 
 	0 = nadie a ganado
	1 = jugador 1 gana
	2 = jugador 2 gana
 */
/**
 * Verificar ganador
 * Return: ganador en r0,  0 si ningun jugador a ganado, 1 para jugador 1, 2 para jugador 2
*/
.global verganador
verganador:
	push {lr}
	/*Variables*/
	col1 .req r2 
	col2 .req r3 
	col3 .req r4 
	col4 .req r5 

	@variables para filas
	fila1 .req r6
	fila2 .req r7
	fila3 .req r8
	fila4 .req r9

	@variable para ganador 
	ganador .req r10
	cont .req r11

	@Load columns from the board
	ldr col1, =col1
	ldr col2, =col2
	ldr col3, =col3
	ldr col4, =col4

	mov cont, #0

bucleV:
	@Load each value
	ldr fila1, [col1]
	ldr fila2, [col2]
	ldr fila3, [col3]
	ldr fila4, [col4]

	@Compare valores
	cmp fila1, fila2 @if(row1 == row2)
	cmpeq fila3, fila4 @if(row3 == row4)
	cmpeq fila1, fila4 @if(row1 == row4 significa que hay ganador)
	moveq ganador, fila1 @winner = row1
	cmp ganador, #0
	bne verfinal		 @si tienen el mismo valor	
	mov ganador, #0 		@ganador = 0

	@Mov to next value
	add col1, #4
	add col2, #4
	add col3, #4
	add col4, #4
	add cont, #1 @cont++
	cmp cont, #4 @while cont < 4
	bne bucleV 	@loop loopVertical

bucleH:
	
	ldr fila1, [column1]
	add col1, #4
	ldr fila2, [column1]
	add col1, #4
	ldr fila3, [column1]
	add col1, #4
	ldr fila4, [column1]
	
	@Comparar valores
	cmp fila1, fila2 @if(row1 == row2)
	cmpeq fila3, fila4 @if(row3 == row4)
	cmpeq fila1, fila4 @if(row1 == row4 significa que hay ganador)
	moveq ganador, row1 @winner = row1
	cmp ganador, #0
	bne verfinal		 @si tienen el mismo valor	
	mov ganador, #0 		@ganador = 0

	
	ldr fila1, [col2]
	add col2, #4
	ldr fila2, [col2]
	add col2, #4
	ldr fila3, [col2]
	add col2, #4
	ldr fila4, [col2]

	
	cmp fila1, fila2 @if(row1 == row2)
	cmpeq fila3, fila4 @if(row3 == row4)
	cmpeq fila1, fila4 @if(row1 == row4 significa que hay ganador)
	moveq ganador, fila1 @winner = row1
	cmp ganador, #0
	bne verfinal		@si tienen el mismo valor	
	mov ganador, #0 		@ganador = 0

	
	ldr fila1, [col3]
	add col3, #4
	ldr fila2, [col3]
	add col3, #4
	ldr fila3, [col3]
	add col3, #4
	ldr fila4, [col3]
	
	
	cmp fila1, fila2 @if(row1 == row2)
	cmpeq fila3, fila4 @if(row3 == row4)
	cmpeq fila1, fila4 @if(row1 == row4 significa que hay ganador)
	moveq ganador, fila1 @winner = row1
	cmp ganador, #0
	bne verfinal		 @si tienen el mismo valor	
	mov ganador, #0 		@ganador = 0

	
	ldr fila1, [col4]
	add col4, #4
	ldr fila2, [col4]
	add col4, #4
	ldr fila3, [col4]
	add col4, #4
	ldr fila4, [col4]
	
	
	cmp fila1, fila2 @if(row1 == row2)
	cmpeq fila3, fila4 @if(row3 == row4)
	cmpeq fila1, fila4 @if(row1 == row4 significa que hay ganador)
	moveq ganador, fila1 @winner = row1
	cmp ganador, #0
	bne verfinal		@si tienen el mismo valor
	mov ganador, #0 		@ganador = 0

	/*@Reload all the values
	ldr col1, =col1
	ldr col2, =col2
	ldr col3, =col3
	ldr col4, =col4*/

verdiagonales:
	@Reload values
	ldr col1, =col1
	ldr col2, =col2
	ldr col3, =col3
	ldr col4, =col4

	darribaabajo:
		ldr fila1, [col1]
		add col2, #4
		ldr fila2, [col2]
		add col3, #8
		ldr fila3, [col3]
		add col4, #12
		ldr fila4, [col4]

		@Compare each value
		cmp fila1, fila2 @if(fila1 == fila2)
		cmpeq fila3, fila4 @if(fila3 == fila4)
		cmpeq fila1, fila4 @if(fila1 == fila4 significa que hay ganador)
		moveq ganador, fila1 @winner = row1
		cmp ganador, #0
		bne verfinal		@si tienen el mismo valor	
		mov ganador, #0 		@ganador = 0

	
	darribaabajo:
		add col1, #12
		ldr fila1, [col1]
		add col2, #4
		ldr fila2, [col2]
		sub col3, #4
		ldr fila3, [col3]
		sub col4, #12
		ldr fila4, [col4]
		
		@Compare each value
		cmp fila1, fila2 @if(row1 == row2)
		cmpeq fila3, fila4 @if(row3 == row4)
		cmpeq fila1, fila4 @if(row1 == row4 significa que hay ganador)
		moveq ganador, fila1 @winner = row1
		cmp ganador, #0
		bne verfinal		@si tienen el mismo valor	
		mov ganador, #0 		@ganador = 0

verfinal:
	mov r0, ganador @move the winner to r0
	@Unlink all variables from registers
	.unreq col1
	.unreq col2
	.unreq col3
	.unreq col4
	.unreq fila1
	.unreq fila2
	.unreq fila3
	.unreq fila4
	.unreq ganador
	.unreq cont
	pop {lr}
	mov pc, lr @return r0