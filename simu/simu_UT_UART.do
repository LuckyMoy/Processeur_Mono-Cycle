vlib work
vcom -2008 ../src/UT_UART.vhd
vcom -2008 ../src/UART_reg.vhd
vcom -2008 ../src/UAL.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 ../src/sign_ext.vhd
vcom -2008 ../src/register_bench.vhd
vcom -2008 ../src/data_mem.vhd
vcom -2008 UT_UART_TB.vhd

vsim work.UT_UART_TB
add wave -position end sim:/*


# Configurer le radix en hexa pour chaque signal
radix -hexadecimal 

run 85 ns
