// Ashton Tolman
// RCET3373
// Lab2PICpt3
// https://github.com/Ashton-Tolman/Semester-5-Lab-2.git

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
    CLRF 0x87	    ; TristC sets all portC pins as outputs
    CLRF 0x95	    ; Set WPUB low to turn pull ups off
    
    BCF  0x03, 6    ;
    BCF  0x03, 5    ; Set bank 0 active
    CLRF 0x06	    ; Clear portB
    CLRF 0x07	    ; Clear portC
		    ; OPTION_REG RBPU-not is default high meaning disabled
		    ; IOCB portB interrupt-on-change disabled default
		    ; 	
    goto Main
    
Main:
    // main goes here
    BCF 0x03,6     ;Set Bank 0
    BCF 0x03,5     ;Set Bank 0
	
    Test7:
    BTFSS 0x06,7    ;Skip next instruction if RB7 is high
    GOTO Test6      ;If RB7 low move to next bit
    GOTO Display7   ;If RB7 high display 7
	
    Test6:
    BTFSS 0x06,6    ;Skip next instruction if RB6 is high
    GOTO Test5      ;If RB6 low move to next bit
    GOTO Display6   ;If RB6 high display 6
	
    Test5:
    BTFSS 0x06,5    ;Skip next instruction if RB5 is high
    GOTO Test4      ;If RB5 low move to next bit
    GOTO Display5   ;If RB5 high display 5
	
    Test4:
    BTFSS 0x06,4    ;Skip next instruction if RB4 is high 
    GOTO Test3      ;If RB4 low move to next bit
    GOTO Display4   ;If RB4 high display 4
	
    Test3:
    BTFSS 0x06,3    ;Skip next instruction if RB3 is high 
    GOTO Test2      ;If RB3 low move to next bit
    GOTO Display3   ;If RB3 high display 3
	
    Test2:
    BTFSS 0x06,2    ;Skip next instruction if RB2 is high
    GOTO Test1      ;If RB2 low move to next bit
    GOTO Display2   ;If RB2 high display 2
	
    Test1:
    BTFSS 0x06,1    ;Skip next instruction if RB1 is high 
    GOTO Test0      ;If RB1 low move to next bit
    GOTO Display1   ;If RB1 high display 1
	
    Test0:
    BTFSS 0x06,0    ;Skip next instruction if RB0 is high
    GOTO DisplaySign;If RB0 is low, display $
    GOTO Display0   ;If RB0 high display 0
	
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
	
    DisplaySign:
    MOVLW 0x24      ;Select the character set for display $
    MOVWF 0x07      ;Send W to PortC
	
    goto Main
End