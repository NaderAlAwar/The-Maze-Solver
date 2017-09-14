	list	p=16f84a
	radix	hex
	include	"p16f84A.inc"

count1	equ	d'12'
count2	equ	d'13'
count3	equ	d'14'
tempchar	equ	d'15'
lol	equ	d'16'
cursorstate	equ	d'17'
progstate	equ	d'18'
pos1	equ	d'19'
pos2	equ	d'20'
pos3	equ	d'21'
pos4	equ	d'22'
pos5	equ	d'23'
pos6	equ	d'24'
pos7	equ	d'25'
pos8	equ	d'26'
pos9	equ	d'27'
pos10	equ	d'28'
pos11	equ	d'29'
pos12	equ	d'30'
pos13	equ	d'31'
pos14	equ	d'32'
pos15	equ	d'33'
pos16	equ	d'34'
pos17	equ	d'35'
pos18	equ	d'36'
pos19	equ	d'37'
pos20	equ	d'38'
startpos	equ	d'39'		;holds value of S when calling solveMaze
currentIter	equ	d'40'		;keeps track of how many loops have taken place
num1	equ	d'41'			;ITR0x
num2	equ	d'42'			;ITRx0
currentPos	equ	d'43'		;current position in mainMazeLoop
tempCurrentPos	equ	d'44'	;temporary holds current position (for inc/decrementing)
posContents	equ	d'45'		;indAddress stores its results here
indAddressPointer	equ	d'46'		;holds the values 19 -> 38
obstacleState	equ	d'46'	;what stage in obstacle mode
obstaclesPlaced	equ	d'47'	;how many obstacles remaining
cursorPos	equ	d'48'		;for obstacle mode, position of cursor
currentReg	equ	d'49'		;which register we are currently in (for FSR)



	org	0x0
	goto main
	org	0x04
	btfsc	INTCON, RBIF
	goto	rbints

main
	clrf	PORTB
	clrf	PORTA
	bsf	STATUS, RP0
	movlw	b'11110000'				;used to set the inputs
	movwf	TRISB
	movlw	b'00000000'				;used to set outputs
	movwf	TRISA
	bcf	STATUS, RP0
	call	initialize
	call	welcome
	call	choosemode
	movlw	b'00000001'
	movwf	progstate				;state: select mode
	movlw	b'10101000'
	movwf	INTCON
	movlw	b'00000001'
	movwf	cursorstate				;set initial cursor state to default
	goto	LOOP2

initialize		MOVLW	b'00010'		;initializes the lcd
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'00010'
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'01000'
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'00000'
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'01111'
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'00000'
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'00001'
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'00000'
	MOVWF	PORTA
	CALL	ET
	MOVLW	b'00110'
	MOVWF	PORTA
	CALL	ET	
	return

sendchar	movwf	tempchar
	andlw	b'11110000'
	movwf	lol
	rrf	lol, 1
	rrf	lol, 1
	rrf	lol, 1
	rrf	lol, 1
	movlw	b'00010000'
	iorwf	lol, 0
	movwf	PORTA
	call	ET
	movlw	b'00001111'
	andwf	tempchar, 0
	iorlw	b'00010000'
	movwf	PORTA
	call	ET	
	return

movecursor	movwf	tempchar
	andlw	b'11110000'
	movwf	lol
	rrf	lol, 1
	rrf	lol, 1
	rrf	lol, 1
	rrf	lol, 0
	movwf	PORTA
	call	ET
	movlw	b'00001111'
	andwf	tempchar, 0
	movwf	PORTA
	call	ET	
	return

welcome	movlw	b'00100000'
	call	sendchar
	movlw	b'00100000'
	call	sendchar
	movlw	b'00100000'					;3 spaces
	call	sendchar
	movlw	b'01001101'	;M
	call	sendchar
	movlw	b'01000001'	;A
	call	sendchar
	movlw	b'01011010'	;Z
	call	sendchar
	movlw	b'01000101'	;E
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01010011'	;S
	call	sendchar
	movlw	b'01001111'	;O
	call	sendchar
	movlw	b'01001100'	;L
	call	sendchar
	movlw	b'01010110'	;V
	call	sendchar
	movlw	b'01000101'	;E
	call	sendchar
	movlw	b'01010010'	;R
	call	sendchar
	call	delay1
	movlw	b'00000'
	movwf	PORTA
	call	ET
	movlw	b'00001'
	movwf	PORTA
	call	ET
	return

choosemode	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00101010'					;cursor
	call	sendchar	
	movlw	b'01000100'					;D
	call	sendchar
	movlw	b'01000101'
	call	sendchar					;E
	movlw	b'01000110'					;F
	call	sendchar
	movlw	b'01000001'
	call	sendchar					;A
	movlw	b'01010101'
	call	sendchar						;U
	movlw	b'01001100'
	call	sendchar					;L
	movlw	b'01010100'
	call	sendchar					;T
	movlw	b'01100'
	movwf	PORTA
	call	ET
	movlw	b'00000'
	movwf	PORTA
	call	ET							;newline
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01001111'					;O
	call	sendchar
	movlw	b'01000010'
	call	sendchar					;B
	movlw	b'01010011'
	call	sendchar					;S
	movlw	b'01010100'
	call	sendchar					;T
	movlw	b'01000001'
	call	sendchar					;A
	movlw	b'01000011'
	call	sendchar					;C
	movlw	b'01001100'
	call	sendchar					;L
	movlw	b'01000101'
	call	sendchar					;E
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01001101'					;M
	call	sendchar
	movlw	b'01000001'					;A
	call	sendchar
	movlw	b'01011010'					;Z
	call	sendchar
	movlw	b'01000101'					;E
	call	sendchar

	return


rbints	bcf	INTCON, RBIF
	btfsc	progstate, 0				
	goto	modeSelectInts
	btfsc	progstate, 1
	goto	modeDefaultInts
	btfsc	progstate, 2
	goto	placeObstacleMode
	btfsc	progstate, 3
	goto	modeMazeInts
	retfie

modeSelectInts	btfss	PORTB, 4 		;interrupts for state: select
	call	movepointer
	btfss	PORTB, 5
	call	confirmmode
	retfie

modeDefaultInts		movlw	b'00010111'					;23 register for position 5
	btfss	PORTB, 5		;interrupts for state: default
	call	solveMaze
	retfie	

modeMazeInts	return
	

placeObstacleMode			
	
	btfss	PORTB, 4
	call	moveCursorObstacle
	btfss	PORTB, 5
	call	placeObstacle
	retfie

newLinePos	movlw	b'11000000'					;newline
	call	movecursor
	retfie
	

moveCursorObstacle		incf	cursorPos, 1
	movlw	cursorPos
	movwf	FSR
	
	movlw	b'00000000'
	addwf	INDF, 0
	movwf	cursorPos
	call	movecursor									; go to next location


;	movlw	b'10001000'
;	subwf	cursorPos, 0								;checking if we're at last location in line
;	decfsz	W, 0
;	call	newLinePos
;	movlw	b'11001000'
;	subwf	cursorPos, 0
;	decfsz	W, 0
;	call	solveMaze
	
	return
	
	
	

placeObstacle	movlw	b'11111111'
	call	sendchar
	return

movepointer	btfsc	cursorstate, 0
	goto	onetwo
	btfsc	cursorstate, 1
	goto	twothree
	btfsc	cursorstate, 2
	goto	threeone
finish	return
	
onetwo	movlw	b'10000011'
	call	movecursor					;position one
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'11000000'
	call	movecursor					;position two
	movlw	b'00101010'					;pointer *
	call	sendchar
	bcf	cursorstate, 0
	bsf	cursorstate, 1	
	goto	finish

twothree	movlw	b'11000000'
	call	movecursor					;position two
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'11001011'
	call	movecursor					;position three
	movlw	b'00101010'					;pointer *
	call	sendchar
	bcf	cursorstate, 1
	bsf	cursorstate, 2	
	goto	finish
	
threeone	movlw	b'11001011'
	call	movecursor					;position three
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'10000011'
	call	movecursor					;position one
	movlw	b'00101010'					;pointer *
	call	sendchar
	bcf	cursorstate, 2
	bsf	cursorstate, 0	
	goto	finish	

confirmmode		movlw	b'00000001'
	call	movecursor					;erases screen
	btfsc	cursorstate, 0
	goto	definitialize
	btfsc	cursorstate, 1
	goto	obstacleMode
	btfsc	cursorstate, 2
	goto	mazeMode
	return


obstacleMode	movlw	b'00000100'		;state: obstacle
	movwf	progstate
	bcf	PORTB, 3
	movlw	b'01010011'		
	movwf	pos1
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos2
	call	sendchar
	movlw	b'01011111'
	movwf	pos3
	call	sendchar
	movlw	b'01011111'
	movwf	pos4
	call	sendchar
	movlw	b'01011111'
	movwf	pos5
	call	sendchar					;empty
	movlw	b'01011111'					;empty
	movwf	pos6
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos7
	call	sendchar				
	movlw	b'01011111'
	movwf	pos8
	call	sendchar
	movlw	b'01011111'
	movwf	pos9
	call	sendchar
	movlw	b'01011111'
	movwf	pos10
	call	sendchar					;empty
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01010011'					;S
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01000000'					;@
	call	sendchar
	movlw	b'11000000'					;newline
	call	movecursor
	movlw	b'01011111'					;E
	movwf	pos11
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos12
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos13
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos14
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos15
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos16
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos17
	call	sendchar				
	movlw	b'01011111'					;empty
	movwf	pos18
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos19
	call	sendchar
	movlw	b'01000101'					;E
	movwf	pos20
	call	sendchar					
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00110000'					;0
	call	sendchar
	movlw	b'00101100'					;,
	call	sendchar
	movlw	b'00110000'					;0
	call	sendchar
	movlw	b'00000001'					;state of placing obstacles
	movwf	obstacleState
	movlw	b'10000000'					;move cursor to beginning of first line
	movwf	cursorPos
	call	movecursor
;	movlw	b'00010011'					;register 19 (pos 1)
	return

mazeMode	movlw	b'00001000'			;state: maze
	movwf	progstate
	movlw	b'01011111'		
	movwf	pos1
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos2
	call	sendchar
	movlw	b'01011111'
	movwf	pos3
	call	sendchar
	movlw	b'01011111'
	movwf	pos4
	call	sendchar
	movlw	b'01011111'
	movwf	pos5
	call	sendchar					;empty
	movlw	b'01011111'					;empty
	movwf	pos6
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos7
	call	sendchar				
	movlw	b'01011111'
	movwf	pos8
	call	sendchar
	movlw	b'01011111'
	movwf	pos9
	call	sendchar
	movlw	b'01011111'
	movwf	pos10
	call	sendchar					;empty
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01010011'					;S
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01000000'					;@
	call	sendchar
	movlw	b'11000000'					;newline
	call	movecursor
	movlw	b'01011111'					;E
	movwf	pos11
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos12
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos13
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos14
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos15
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos16
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos17
	call	sendchar				
	movlw	b'01011111'					;empty
	movwf	pos18
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos19
	call	sendchar
	movlw	b'01000101'					;E
	movwf	pos20
	call	sendchar					
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00110000'					;0
	call	sendchar
	movlw	b'00101100'					;,
	call	sendchar
	movlw	b'00110000'					;0
	call	sendchar
	movlw	b'00000001'					;state of placing obstacles
	movwf	obstacleState
	movlw	b'10000000'					;move cursor to beginning of first line
	movwf	cursorPos
;	movlw	b'00010011'					;register 19 (pos 1)
	goto	finish

	retfie

definitialize	movlw	b'00000010'		;state: default
	movwf	progstate
	bcf	PORTB, 2
	movlw	b'11111111'		;obstacle
	movwf	pos1
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos2
	call	sendchar
	movlw	b'01011111'
	movwf	pos3
	call	sendchar
	movlw	b'01011111'
	movwf	pos4
	call	sendchar
	movlw	b'01011111'
	movwf	pos5
	call	sendchar					;empty
	movlw	b'01010011'					;S
	movwf	pos6
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos7
	call	sendchar				
	movlw	b'01011111'
	movwf	pos8
	call	sendchar
	movlw	b'01011111'
	movwf	pos9
	call	sendchar
	movlw	b'01011111'
	movwf	pos10
	call	sendchar					;empty
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01010011'					;S
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'01000000'					;@
	call	sendchar
	movlw	b'11000000'					;newline
	call	movecursor
	movlw	b'01000101'					;E
	movwf	pos11
	call	sendchar
	movlw	b'11111111'					;obstacle
	movwf	pos12
	call	sendchar
	movlw	b'01011111'					;empty
	movwf	pos13
	call	sendchar
	movlw	b'11111111'					;obstacle
	movwf	pos14
	call	sendchar
	movlw	b'11111111'					;obstacle
	movwf	pos15
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos16
	call	sendchar					
	movlw	b'01011111'					;empty
	movwf	pos17
	call	sendchar				
	movlw	b'01011111'					;empty
	movwf	pos18
	call	sendchar
	movlw	b'11111111'					;obstacle
	movwf	pos19
	call	sendchar
	movlw	b'11111111'					;obstacle
	movwf	pos20
	call	sendchar					
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00110000'					;0
	call	sendchar
	movlw	b'00101100'					;,
	call	sendchar
	movlw	b'00110101'					;5
	call	sendchar
	
	goto	finish

solveMaze	movwf startpos				;save value of location of S					
	movlw	b'00001110'
	call	movecursor					;blink OFF
	movlw	b'00001001'					;holds number of loops for num2
	movwf	currentIter					;starts at 9, decrement each loop
	movlw	b'10001011'					;we need to erase the writing to the right
	call	movecursor
	movlw	b'01001001'					;I
	call	sendchar
	movlw	b'01010100'					;T
	call	sendchar
	movlw	b'01010010'					;R
	call	sendchar
	movlw	b'00110000'					;0
	call	sendchar
	movlw	b'00110001'					;1
	call	sendchar
	movlw	b'11001101'					;bottom right
	call	movecursor				
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00100000'					;space
	call	sendchar
	movlw	b'00110000'					;set num1 to 0
	movwf	num1
	movlw	b'00110000'					;set num2 to 0
	movwf	num2
mazeLoop	movlw	b'00000000'
	addwf	startpos, 0			;23
	movwf	currentReg			;23

	incf	num1, 1				;increment num1
	decfsz	currentIter, 1				;checking if we need to increment num2
	goto	resumeLoop
	goto	mazeLoopIter
resumeLoop	movlw	b'10001110'
	call	movecursor
	movlw	num2
	call	indAddress
	call	sendchar
	movlw	num1
	call	indAddress
	call	sendchar
	movlw	b'01101110'
	addwf	currentReg, 0
	movwf	currentPos			;position on scree
mainLoop	incf	currentReg, 0
	movwf	tempCurrentPos
	movlw	d'27'
	subwf	tempCurrentPos, 0
	decfsz	W, 0
	goto	checkBotRight
resumeMainLoop	movlw	d'00'
	addwf	tempCurrentPos, 0
	call	indAddress
	movlw	b'01000011'			;checking for E
	decfsz	posContents, 0
	goto	pathFound
	goto	updatePos
	
updatePos	movlw	b'00101010'
	movwf	INDF
	movlw	b'01101110'
	addwf	currentReg, 0
	call	movecursor
	movlw	b'00101010'
	call	sendchar
	goto	mainLoop

pathFound	return

checkBotRight	movlw	d'37'
	subwf	tempCurrentPos, 0
	decfsz	W, 0
	goto	goLeft
	goto	resumeMainLoop


goLeft	return
;mainMazeLoop
;	incf	currentReg, 0		;24
;;	movwf	currentReg
;	movwf	tempCurrentPos		;24
;	movlw	b'00011100'			;28
;	subwf	tempCurrentPos, 0
;	decfsz	W, 0
;	goto	goright
;	goto	goleft
;resume1
;;	goto	checkBoundsBotRight
;resume2
;	movlw	b'00000000'
;	addwf	tempCurrentPos, 0
;	movwf	tempCurrentPos
;	addwf	startpos, 0
;	
;goright	call	indAddress					;get contents of current position
;	movlw	b'01000100'					;check if end
;	subwf	posContents, 0
;	decfsz	W, 0
;	goto	pathFound
;	movlw	b'01011110'					;to check if empty	
;	subwf	posContents, 0
;	decfsz	W,0
;	goto	updatePos
;goleft	return
;
;pathFound	return	
;	
mazeLoopIter	incf	num2, 1			;increment num2
	movlw	b'00001001'
	movwf	currentIter					;reset currentIter
	movlw	b'00110000'					;set num1 to 0
	movwf	num1
	goto	resumeLoop	
;
;;checkBoundsTopRight	movlw	b'00001001'
;;	subwf	tempCurrentPos, 0
;;	decfsz	W, 0
;;	goto	resume1
;;	goto	goleft
;;
;;checkBoundsBotRight	movlw	b'00010011'
;;	subwf	tempCurrentPos, 0
;;	decfsz	W, 0
;;	goto	resume2
;;	goto	goleft
;	
;
;updatePos	movlw	b'01101110'
;	addwf	tempCurrentPos, 0
;	movwf	currentPos
;	call	movecursor
;	movlw	b'00101010'				;* visited
;	call	sendchar
;	movlw	b'00000000'
;	addwf	currentReg, 0
;	movwf	FSR
;	movlw	b'00101010'				;* visited
;	movwf	INDF
;	goto	mainMazeLoop
;
indAddress	movwf	FSR
	movlw	b'00000000'
	addwf	INDF, 0
	movwf	posContents
	return

delay1	movlw	H'00'				;for 2 seconds delay
	movwf	count3
	movwf	count2
	movlw	0x0a
	movwf	count1

loop1	incfsz	count3, F			;for 2 seconds delay
	goto	loop1
	incfsz	count2, F
	goto	loop1
	decfsz	count1, F				
	goto	loop1
	return

ET	BSF	PORTB, 1					;for lcd initialization
	NOP
	BCF	PORTB, 1
	CALL	DELAY
	RETURN

DELAY	MOVLW	H'00'				;for lcd initialization
	MOVWF	count2
	MOVLW	0x33
	MOVWF	count1

LOOP	INCFSZ	count2, F			;for lcd initialization
	GOTO LOOP
	DECFSZ	count1, F
	GOTO LOOP
	RETURN
LOOP2	goto LOOP2					;infinite loop

	end
