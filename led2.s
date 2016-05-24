.nolist
.include "m8def.inc"
.list

.org 0
    rjmp MAIN
    rjmp IRQ_KEYS

.org INT_VECTORS_SIZE
MAIN:
    ldi r16, low(RAMEND)
    out SPL, r16
    ldi r16, high(RAMEND)
    out SPH, r16
    
    ldi r16, (1<<INT0)
    out GIMSK, r16
    ldi r16, (1<<ISC01) | (1<<ISC00)
    out MCUCR, r16
    
    ldi r16, 0xFF
    out DDRB, r16
    ldi r16, 0x00
    out DDRC, r16
    out DDRD, r16
    out PORTB, r16
    
    ldi r16, 0x00
    
    sei

LOOP:
    out PORTB, r16
    rjmp LOOP
    
IRQ_KEYS:
    ldi r17, 0x01
    sbic PINC, PINC0
    eor r16, r17
    ldi r17, 0x02
    sbic PINC, PINC1
    eor r16, r17
    ldi r17, 0x04
    sbic PINC, PINC2
    eor r16, r17
    ldi r17, 0x08
    sbic PINC, PINC3
    eor r16, r17
    reti

