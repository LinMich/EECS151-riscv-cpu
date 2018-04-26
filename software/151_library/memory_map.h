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
#define X0_WRITE (*((volatile uint32_t*)0x80010000))
#define X1_WRITE (*((volatile uint32_t*)0x80010004))
#define Y0_WRITE (*((volatile uint32_t*)0x80010008))
#define Y1_WRITE (*((volatile uint32_t*)0x8001000c))
#define COLOR_WRITE (*((volatile uint32_t*)0x80010010))
#define FIRE_WRITE (*((volatile uint32_t*)0x80010014))

