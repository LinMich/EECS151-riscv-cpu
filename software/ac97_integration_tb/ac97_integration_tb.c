#include "memory_map.h"

// This program sends the PCM samples -50, ..., 50 to your AC97 sample FIFO
int main(void) {
    int i;
    for (i = -50; i <= 50; i++) {
        while(AC97_FULL);
        AC97_DATA = i;
    }

    // Once we are done, the program should just stop sending samples
    jump_here: i = 0;
    goto jump_here;
    return 0;
}
