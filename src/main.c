#include <util/delay.h>
#include "led.h"

int main(void) {
    led_init();

    while(1) {
        led_set();
        _delay_ms(200);

        led_clear();
        _delay_ms(100);
    }

    return 0;
}
