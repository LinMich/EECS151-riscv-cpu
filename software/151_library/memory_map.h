#include "types.h"

#define COUNTER_RST (*((volatile uint32_t*) 0x80000018))
#define CYCLE_COUNTER (*((volatile uint32_t*)0x80000010))
#define INSTRUCTION_COUNTER (*((volatile uint32_t*)0x80000014))

#define GPIO_FIFO_EMPTY (*((volatile uint32_t*)0x80000020) & 0x01)
#define GPIO_FIFO_DATA (*((volatile uint32_t*)0x80000024))
#define DIP_SWITCHES (*((volatile uint32_t*)0x80000028) & 0xFF)
#define LED_CONTROL (*((volatile uint32_t*)0x80000030))

#define TONE_GEN_OUTPUT_ENABLE (*((volatile uint32_t*)0x80000034))
#define TONE_GEN_TONE_INPUT (*((volatile uint32_t*)0x80000038))

#define I2S_FULL (*((volatile uint32_t*)0x80000040) & 0x01)
#define I2S_DATA (*((volatile uint32_t*)0x80000044))

// I2C Controller MMIO - reading
#define I2C_CONTROLLER_READY (*((volatile uint32_t*)0x80000100) & 0x1)
#define I2C_CONTROLLER_READ_DATA_VALID (*((volatile uint32_t*)0x80000100) & 0x2)
#define I2C_READ_DATA (*((volatile uint32_t*)0x80000104) & 0xFFFF)

// I2C Controller MMIO - writing
#define I2C_REG_ADDR (*((volatile uint32_t*)0x80000108))
#define I2C_WRITE_DATA (*((volatile uint32_t*)0x8000010C))
#define I2C_SLAVE_ADDR (*((volatile uint32_t*)0x80000110))
#define I2C_CONTROLLER_FIRE (*((volatile uint32_t*)0x80000114))

// HDMI Signals
#define LE_X0 (*((volatile uint32_t*)0x90010000))
#define LE_X1 (*((volatile uint32_t*)0x90010004))
#define LE_Y0 (*((volatile uint32_t*)0x90010008))
#define LE_Y1 (*((volatile uint32_t*)0x9001000c))
#define LE_COLOR (*((volatile uint32_t*)0x90010010))
#define LE_FIRE (*((volatile uint32_t*)0x90010014))

