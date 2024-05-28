vlib work
vcom -2008 ../src/Processor_UART3.vhd
vcom -2008 ../src/UT_UART2.vhd
vcom -2008 ../src/UART_reg.vhd
vcom -2008 ../src/VIC_UART2.vhd
vcom -2008 ../src/UAL.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 ../src/sign_ext.vhd
vcom -2008 ../src/register_bench.vhd
vcom -2008 ../src/data_mem.vhd
vcom -2008 ../src/instructions_decoder_VIC.vhd
vcom -2008 ../src/reg32.vhd
vcom -2008 ../src/UC_VIC.vhd
vcom -2008 ../src/Instructions_Unit_UART3.vhd
vcom -2008 ../src/instruction_memory_UART3.vhd
vcom -2008 ../src/PC_update_unit_VIC.vhd
vcom -2008 ../src/PC_reg.vhd
vcom -2008 Processor_UART3_TB.vhd

vsim work.PROCESSOR_UART3_TB
add wave -position end sim:/*


# Configurer le radix en hexa pour chaque signal
radix -hexadecimal 

run 8100 ns