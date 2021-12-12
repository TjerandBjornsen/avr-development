#include "led.h"

#include <avr/io.h>

void led_init(void) {
    DDRB |= (1 << PB5);
}

void led_set(void) {
    PORTB |= (1 << PB5);
}

void led_clear(void) {
    PORTB &= ~(1 << PB5);
}
