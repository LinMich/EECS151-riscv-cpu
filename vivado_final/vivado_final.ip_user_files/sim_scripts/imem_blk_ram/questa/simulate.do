onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib imem_blk_ram_opt

do {wave.do}

view wave
view structure
view signals

do {imem_blk_ram.udo}

run -all

quit -force
