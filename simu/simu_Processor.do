vlib work
vcom -2008 ../src/Processor.vhd
vcom -2008 ../src/UT.vhd
vcom -2008 ../src/UAL.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 ../src/sign_ext.vhd
vcom -2008 ../src/register_bench.vhd
vcom -2008 ../src/data_mem.vhd
vcom -2008 ../src/instructions_decoder.vhd
vcom -2008 ../src/reg32.vhd
vcom -2008 ../src/UC.vhd
vcom -2008 ../src/Instructions_Unit.vhd
vcom -2008 ../src/instruction_memory.vhd
vcom -2008 ../src/PC_update_unit.vhd
vcom -2008 ../src/PC_reg.vhd
vcom -2008 Processor_TB.vhd

vsim work.PROCESSOR_TB
add wave -position end sim:/*


# Configurer le radix en hexa pour chaque signal
radix -hexadecimal 

run 1100 ns