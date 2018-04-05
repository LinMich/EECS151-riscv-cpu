onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+dmem_blk_ram -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dmem_blk_ram xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {dmem_blk_ram.udo}

run -all

endsim

quit -force
