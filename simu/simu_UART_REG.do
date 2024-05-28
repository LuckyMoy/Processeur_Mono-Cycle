vlib work

vcom -2008 ../src/UART_reg.vhd
vcom -2008 UART_Reg_TB.vhd

vsim work.UART_REG_TB
add wave -position end sim:/*
radix -hexadecimal

run 150 ns