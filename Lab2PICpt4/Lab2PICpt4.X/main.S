// Ashton Tolman
// RCET3373
// Lab2PICpt4
// https://github.com/Ashton-Tolman/Semester-5-Lab-2.git
// linker code:-Wl,-presetVect=0000h,-pcode=0008h

; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>

; Reset Vector at 000h. Execution starts here after reset 
PSECT resetVect,class=CODE,delta=2
ResetVector:
    goto Setup
    
    
; Main code section starts at 0008h. User code goes here
PSECT code,class=CODE,delta=2

Setup:
    ; add device setup here
    BSF  0x03, 6    ;
    BSF  0x03, 5    ; Set bank 3 active
    CLRF 0x89	    ; ANSELH set low to make portB digital
    
    BSF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 2 active
    BSF  0x09, 1    ; Turn T1G-not function off
    
    BCF  0x03, 6    ;
    BSF  0x03, 5    ; Set bank 1 active 
    CLRF 0x87	    ; TrisC sets all portC pins as outputs
    MOVLW 0xFF	    ; Put all high literal into W
    MOVWF 0x86      ; Put all highs on TrisB to configure PortB as inputs
    MOVLW 0xFF	    ; Put all high literal into W
    MOVWF 0x95	    ; WPUB
    BCF  0x81, 7    ; OPTION_REG
    
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
    CLRF 0x06	    ; Clear portB
    CLRF 0x07	    ; Clear portC
		    ; IOCB portB interrupt-on-change disabled default
 	
    goto Main
    
Main:
    // main goes here
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
    
    ; Scan Row 1
    MOVLW 0xFE		; Put 11111110 on the TrisB register making RB0 an output
    MOVWF 0x86		; Configure RB0 as an output
    
    TestPnd:
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,5    ;Skip next instruction if RB5 is Low
	GOTO TestStar   ;If RB5 low move to next test
	GOTO DisplayPnd ;If RB5 high display #
	
    TestStar:
	BTFSC 0x06,7    ;Skip next instruction if RB7 is Low
	GOTO TestD      ;If RB7 low move to next test
	GOTO DisplayStar;If RB7 high display *

    TestD:
	BTFSC 0x06,4    ;Skip next instruction if RB4 is Low
	GOTO TestC      ;If RB4 low move to next test
	GOTO DisplayD   ;If RB4 high display D
    
    
    
    TestC:
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
    ; Scan Row 2
    MOVLW 0xFD		; Put 11111101 on the TrisB register making RB1 an output
    MOVWF 0x86		; Configure RB1 as an output
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,4    ;Skip next instruction if RB4 is Low
	GOTO TestB      ;If RB4 low move to next test
	GOTO DisplayC   ;If RB4 high display C
    
    
    
    TestB:
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
    ; Scan Row 3
    MOVLW 0xFB		; Put 11111011 on the TrisB register making RB2 an output
    MOVWF 0x86		; Configure RB2 as an output
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,4    ;Skip next instruction if RB4 is Low
	GOTO TestA      ;If RB4 low move to next test
	GOTO DisplayB   ;If RB4 high display B
    
    
    
    TestA:
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
     ; Scan Row 4
    MOVLW 0xF7	    ; Put 11110111 on the TrisB register making RB3 an output
    MOVWF 0x86	    ; Configure RB3 as an output
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,4    ;Skip next instruction if RB4 is Low
	GOTO Test9      ;If RB4 low move to next test
	GOTO DisplayA   ;If RB4 high display A
    
    
   
    Test9:
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
    ; Scan Row 2
    MOVLW 0xFD	    ; Put 11111101 on the TrisB register making RB1 an output
    MOVWF 0x86	    ; Configure RB1 as an output
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,5    ;Skip next instruction if RB5 is Low
	GOTO Test8      ;If RB5 low move to next test
	GOTO Display9   ;If RB5 high display 9
    
    Test8:
	BTFSC 0x06,6    ;Skip next instruction if RB6 is Low
	GOTO Test7      ;If RB6 low move to next test
	GOTO Display8   ;If RB6 high display 8
    
    Test7:
	BTFSC 0x06,7    ;Skip next instruction if RB7 is Low
	GOTO Test6      ;If RB7 low move to next test
	GOTO Display7   ;If RB7 high display 7
    
    
    
    Test6:
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
    ; Scan Row 3
    MOVLW 0xFB	    ; Put 11111011 on the TrisB register making RB2 an output
    MOVWF 0x86	    ; Configure RB2 as an output
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,5    ;Skip next instruction if RB5 is Low
	GOTO Test5      ;If RB5 low move to next test
	GOTO Display6   ;If RB5 high display 6
    
    Test5:
	BTFSC 0x06,6    ;Skip next instruction if RB6 is Low
	GOTO Test4      ;If RB6 low move to next test
	GOTO Display5   ;If RB6 high display 5
    
    Test4:
	BTFSC 0x06,7    ;Skip next instruction if RB7 is Low
	GOTO Test3      ;If RB7 low move to next test
	GOTO Display4   ;If RB7 high display 4
    
    
    
    Test3:
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
    ; Scan Row 4
    MOVLW 0xF7	    ; Put 11110111 on the TrisB register making RB3 an output
    MOVWF 0x86	    ; Configure RB3 as an output
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,5    ;Skip next instruction if RB5 is Low
	GOTO Test2      ;If RB5 low move to next test
	GOTO Display3   ;If RB5 high display 3
    
    Test2:
	BTFSC 0x06,6    ;Skip next instruction if RB6 is Low
	GOTO Test1      ;If RB6 low move to next test
	GOTO Display2   ;If RB6 high display 2
    
    Test1:
	BTFSC 0x06,7    ;Skip next instruction if RB7 is Low
	GOTO Test0      ;If RB7 low move to next test
	GOTO Display1   ;If RB7 high display 1
    
    

    Test0:
    BCF 0x03, 6	    ;
    BSF 0x03, 5	    ; Set bank 1 active
    ; Scan Row 1
    MOVLW 0xFE	    ; Put 11111110 on the TrisB register making RB0 an output
    MOVWF 0x86	    ; Configure RB0 as an output
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
	BTFSC 0x06,6    ;Skip next instruction if RB6 is Low
	GOTO DisplayDol ;If RB6 low move to next test
	GOTO Display0   ;If RB6 high display 0
    
    
    DisplayPnd:
    MOVLW 0x23      ;Select the character set for display #
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayStar:
    MOVLW 0x2A      ;Select the character set for display *
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayD:
    MOVLW 0x44      ;Select the character set for display D
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayC:
    MOVLW 0x43      ;Select the character set for display C
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayB:
    MOVLW 0x42      ;Select the character set for display B
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayA:
    MOVLW 0x41      ;Select the character set for display A
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display9:
    MOVLW 0x39      ;Select the character set for display 9
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display8:
    MOVLW 0x38      ;Select the character set for display 8
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display7:
    MOVLW 0x37      ;Select the character set for display 7
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display6:
    MOVLW 0x36      ;Select the character set for display 6
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display5:
    MOVLW 0x35      ;Select the character set for display 5
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display4:
    MOVLW 0x34      ;Select the character set for display 4
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display3:
    MOVLW 0x33      ;Select the character set for display 3
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display2:
    MOVLW 0x32      ;Select the character set for display 2
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display1:
    MOVLW 0x31      ;Select the character set for display 1
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display0:
    MOVLW 0x30      ;Select the character set for display 0
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayDol:
    MOVLW 0x24      ;Select the character set for display $
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
End