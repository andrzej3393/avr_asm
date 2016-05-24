.nolist
.include "m8def.inc"
.list

.org 0
    rjmp MAIN ;wektory przerwań
    rjmp IRQ_INT0
    rjmp IRQ_INT1

.org INT_VECTORS_SIZE
MAIN:
    ldi r16, low(RAMEND) ;ustawianie wskaźnika stosu
    out SPL, r16
    ldi r16, high(RAMEND)
    out SPH, r16
    
    ldi r16, (1<<INT0) | (1<<INT1);konfiguracja przerwań INT0 i INT1
    out GIMSK, r16
    ldi r16, (1<<ISC01) | (1<<ISC11)
    out MCUCR, r16
    
    ldi r16, 0xFF ;ustawianie portu B jako wyjście
    out DDRB, r16
    
    ser r16 ;ustawianie portu D jako wejście
    out DDRD, r16
    
    ldi r16, 0x00 ;zerowanie r16 pod licznik
    ldi r17, 0x10 ;r17 = 16
    ldi r18, 0xFF ;r18 = 255
    
    sei
    
LOOP: ;pętla główna
    clr r0
    ldi ZL, low(cyfry << 1)
    ldi ZH, high(cyfry << 1)
    add ZL, r16
    adc ZH, r0
    lpm
    out PORTB, r0
    rjmp LOOP

IRQ_INT0: ;obsługa przerwania INT0
    inc r16
    cpse r17, r16
    reti
    ldi r16, 0x00
    reti

IRQ_INT1: ;obsługa przerwania INT1
    dec r16
    cpse r18, r16
    reti
    ldi r16, 0x0F
    reti

cyfry:
    .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71
