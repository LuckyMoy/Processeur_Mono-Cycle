vlib work
vcom -2008 ../src/VIC_UART.vhd
vcom -2008 VIC_UART_TB.vhd

vsim work.VIC_UART_TB
add wave -position end sim:/*


# Configurer le radix en hexa pour chaque signal
radix -hexadecimal 

run 300 ns