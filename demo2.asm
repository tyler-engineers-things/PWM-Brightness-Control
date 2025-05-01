ORG 0
Start:
	LOAD	TOGGLE9_6
    OUT		B_LED
    
    LOAD    LED9_6A  ; load initial setup 7-4-1-0-...
    OUT     B_LED
    CALL    Delay

    ; A -> C
    LOAD    LED9_6B 
    OUT     B_LED
    
    LOAD	TOGGLE5
    OR		TOGGLE4
    OR		TOGGLE3
    OR		TOGGLE2
    OUT		B_LED
    
    LOAD    LED5_2A
    OUT     B_LED
    CALL    Delay


	LOAD	TOGGLE9
    OR		TOGGLE8
    OR		TOGGLE7
    OR		TOGGLE6
    OUT		B_LED
    
    ; A -> B
    LOAD    LED9_6C
    OUT     B_LED
    CALL    Delay
    
    LOAD	TOGGLE5
    OR		TOGGLE4
    OR		TOGGLE3
    OR		TOGGLE2
    OUT		B_LED

    ; C -> B
    LOAD    LED5_2B
    OUT     B_LED
    CALL    Delay


	LOAD	TOGGLE9
    OR		TOGGLE8
    OR		TOGGLE7
    OR		TOGGLE6
    OUT		B_LED
    
    ; A -> C
    LOAD    LED9_6D
    OUT     B_LED
    
    
    LOAD	TOGGLE5
    OR		TOGGLE4
    OR		TOGGLE3
    OR		TOGGLE2
    OUT		B_LED
    
    LOAD    LED5_2C
    OUT     B_LED
    CALL    Delay
    
    ; B -> A
    LOAD    LED5_2D
    OUT     B_LED
    
    
    LOAD	TOGGLE9
    OR		TOGGLE8
    OR		TOGGLE7
    OR		TOGGLE6
    OUT		B_LED
    
    LOAD    LED9_6E
    OUT     B_LED
    CALL    Delay
    
    ; B -> C
    LOAD    LED9_6F
    OUT     B_LED
    LOAD	TOGGLE5
    OR		TOGGLE4
    OR		TOGGLE3
    OR		TOGGLE2
    OUT		B_LED
    LOAD    LED5_2E
    OUT     B_LED
    CALL    Delay
	
    
    LOAD	TOGGLE9
    OR		TOGGLE8
    OR		TOGGLE7
    OR		TOGGLE6
    OUT		B_LED
    
    ; A -> C
    LOAD    LED9_6G
    OUT     B_LED
    LOAD	TOGGLE1
    OR		TOGGLE0
    OUT		B_LED
    LOAD    LED1_0A
    OUT     B_LED
    CALL    Delay

    ; Done, restart
    JUMP    Start


Delay:
	OUT    Timer
WaitingLoop:
	IN     Timer
	ADDI   -5
	JNEG   WaitingLoop
	RETURN

; Variables
TOGGLE0:	DW &B0000000000000001
TOGGLE1:	DW &B0000000000000010
TOGGLE2:	DW &B0000000000000100
TOGGLE3:	DW &B0000000000001000
TOGGLE4:	DW &B0000000000010000
TOGGLE5:	DW &B0000000000100000
TOGGLE6:	DW &B0000000001000000
TOGGLE7:	DW &B0000000010000000
TOGGLE8:	DW &B0000000100000000
TOGGLE9:	DW &B0000001000000000

TOGGLE9_6:  DW &B0000001111000000

LED9_6A:    DW &B0011 111100001000  ; Init brightness 7,4,1,0
LED9_6B:    DW &B0011 111100000000  ; 7,4,0,0
LED9_6C:    DW &B0011 111000000100  ; 7,0,0,4
LED9_6D:    DW &B0011 000000000100  ; 0,0,0,4
LED9_6E:    DW &B0011 001000000100  ; 1,0,0,4
LED9_6F:    DW &B0011 001000000000  ; 1,0,0,0
LED9_6G:    DW &B0011 000000000000  ; 0,0,0,0

LED5_2A:    DW &B0010 000000001000  ; 0,0,1,0
LED5_2B:    DW &B0010 001000000000  ; 1,0,0,0
LED5_2C:    DW &B0010 001000111000  ; 1,0,7,0 ; new
LED5_2D:    DW &B0010 000000111000  ; 0,0,7,0 ; new
LED5_2E:    DW &B0010 000000111100  ; 0,0,7,4 ; new

LED1_0A:    DW &B0001000000001000  ; 1,0    ; new
                                            ; gone

; IO address constants
LEDs:      EQU 001
Timer:     EQU 002
B_LED:     EQU &H020