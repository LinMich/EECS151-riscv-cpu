#include "ascii.h"
#include "uart.h"
#include "string.h"
#include "types.h"
#include "memory_map.h"

// Low and high sample values of the square wave.
// (Our I2S controller sample width is 24 bits of signed PCM.)
//
// Chosen so that multiplying by 4 doesn't oveflow the 24-bit value.
#define HIGH_AMPLITUDE 0x1FFFF
#define LOW_AMPLITUDE -0x1FFFF

#define BUFFER_LEN 128

typedef void (*entry_t)(void);

int main(void) {
    TONE_GEN_OUTPUT_ENABLE = 1;
    int8_t buffer[BUFFER_LEN];
    uint32_t tone_period = 54 + 54;
    uint32_t counter = 0;

    // Since our I2S controller doesn't have volume control, it's up to us to
    // reduce its volume in software.
    uint32_t volume = 0;

    for (;;) {
        // Set the volume of the I2headphone codec with the DIP switch setting
        volume = DIP_SWITCHES & 0xF;

        // Adjust the tone_period if a push is detected.
        if (!GPIO_FIFO_EMPTY) {
            uint32_t button_state = GPIO_FIFO_DATA;
            if (button_state & 0x1) { // BUTTONS[0]
                counter = 0;
                tone_period += 2;
            } else if (button_state & 0x2) { // BUTTONS[1]
                counter = 0;
                tone_period -= 2;
            } else if (button_state & 0x4) { // BUTTONS[2]
                counter = 0;
                tone_period = 54 + 54;
            }
        }

        if (counter < (tone_period >> 1)) {
            while(I2S_FULL);
            I2S_DATA = HIGH_AMPLITUDE * volume;
            TONE_GEN_TONE_INPUT = tone_period << 4;
            //uwrite_int8s("Sent high.\n");
        }
        else if (counter >= (tone_period >> 1)) {
            while(I2S_FULL);
            I2S_DATA = LOW_AMPLITUDE * volume;
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
