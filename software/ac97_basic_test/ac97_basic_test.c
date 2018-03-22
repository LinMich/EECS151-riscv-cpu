#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "types.h"
#include "memory_map.h"

// Low and high sample values of the square wave
#define HIGH_AMPLITUDE 0x20000
#define LOW_AMPLITUDE -0x20000

#define BUFFER_LEN 128

typedef void (*entry_t)(void);

int main(void) {
    TONE_GEN_OUTPUT_ENABLE = 1;
    int8_t buffer[BUFFER_LEN];
    uint32_t tone_period = 54 + 54;
    uint32_t counter = 0;

    for ( ; ; ) {
        // Set the volume of the AC97 headphone codec with the DIP switch setting
        AC97_VOLUME = DIP_SWITCHES & 0xF;

        // Adjust the tone_period if a rotary wheel spin or push is detected
        if (!GPIO_FIFO_EMPTY) {
            uint32_t button_state = GPIO_FIFO_DATA;
            if ((button_state & 0x1) && (button_state & 0x2)) { // Rotary wheel left spin
                counter = 0;
                tone_period += 2;
            }
            if (!(button_state & 0x1) && (button_state & 0x2)) { // Rotary wheel right spin
                counter = 0;
                tone_period -= 2;
            }
            if (button_state & 0x4) { // Rotary wheel push
                counter = 0;
                tone_period = 54 + 54;
            }
        }

        if (counter < (tone_period >> 1)) {
            while(AC97_FULL);
            AC97_DATA = HIGH_AMPLITUDE;
            TONE_GEN_TONE_INPUT = tone_period << 4;
            //uwrite_int8s("Sent high.\n");
        }
        else if (counter >= (tone_period >> 1)) {
            while(AC97_FULL);
            AC97_DATA = LOW_AMPLITUDE;
            //uwrite_int8s("Sent low.\n");
        }
        counter++;
        if (counter >= tone_period) {
            counter = 0;
        }
        LED_CONTROL = tone_period;
    }

    return 0;
}
