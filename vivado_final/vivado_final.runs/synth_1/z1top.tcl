# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7z020clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.cache/wt [current_project]
set_property parent.project_path /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/software/assembly_tests/assembly_tests.coe
add_files /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/software/echo/echo.coe
read_verilog {
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/riscv_core/Opcode.vh
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/util.vh
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/Opcode.vh
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/src/util.vh
}
read_verilog -library xil_defaultlib {
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/riscv_core/ALU.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/button_parser.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/edge_detector.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/uart.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/uart_receiver.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/z1top.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/async_fifo.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/fifo.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/riscv_core/control_unit.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/riscv_core/instruction_decoder.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/branch_control.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/riscv_core/Riscv151.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/reg_file.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/ALU.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/Riscv151.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/instruction_decoder.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/hazard_unit.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/control_unit.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/mem_read_decoder.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/io_circuits/fifo.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/audio/tone_generator.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/riscv_core/reg_file.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/io_circuits/button_parser.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/synchronizer.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/mem_control.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/io_circuits/async_fifo.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/io_circuits/uart.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/uart_transmitter.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/io_circuits/uart_receiver.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/src/z1top.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/vivado_final/vivado_final.srcs/sources_1/imports/riscv_core/branch_control.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/io_circuits/debouncer.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/riscv_core/UART_controller.v
  /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/audio/i2s_controller.v
}
read_ip -quiet /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/memories/imem_blk_ram/imem_blk_ram.xci
set_property used_in_implementation false [get_files -all /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/memories/imem_blk_ram/imem_blk_ram_ooc.xdc]

read_ip -quiet /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/memories/dmem_blk_ram/dmem_blk_ram.xci
set_property used_in_implementation false [get_files -all /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/memories/dmem_blk_ram/dmem_blk_ram_ooc.xdc]

read_ip -quiet /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/memories/bios_mem/bios_mem.xci
set_property used_in_implementation false [get_files -all /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/memories/bios_mem/bios_mem_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/PYNQ-Z1_C.xdc
set_property used_in_implementation false [get_files /home/cc/eecs151/sp18/class/eecs151-aar/sp18_team69/hardware/src/PYNQ-Z1_C.xdc]


synth_design -top z1top -part xc7z020clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef z1top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file z1top_utilization_synth.rpt -pb z1top_utilization_synth.pb"