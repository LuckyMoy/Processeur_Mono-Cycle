vlib work
vcom -2008 ../src/Processor_UART1.vhd
vcom -2008 ../src/UT_UART.vhd
vcom -2008 ../src/UAL.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 ../src/sign_ext.vhd
vcom -2008 ../src/register_bench.vhd
vcom -2008 ../src/data_mem.vhd
vcom -2008 ../src/instructions_decoder_VIC.vhd
vcom -2008 ../src/reg32.vhd
vcom -2008 ../src/UC_VIC.vhd
vcom -2008 ../src/Instructions_Unit_UART.vhd
vcom -2008 ../src/instruction_memory_UART1.vhd
vcom -2008 ../src/PC_update_unit_VIC.vhd
vcom -2008 ../src/PC_reg.vhd
vcom -2008 Processor_UART1_TB.vhd

vsim work.PROCESSOR_UART1_TB
add wave -position end sim:/*


# Configurer le radix en hexa pour chaque signal
radix -hexadecimal 

run 2100 ns