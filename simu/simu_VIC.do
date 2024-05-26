vlib work
vcom -2008 ../src/VIC.vhd
vcom -2008 VIC_TB.vhd

vsim work.VIC_TB
add wave -position end sim:/*


# Configurer le radix en hexa pour chaque signal
radix -hexadecimal 

run 300 ns