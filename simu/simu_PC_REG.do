vlib work

vcom -2008 ../src/PC_reg.vhd
vcom -2008 PC_reg_TB.vhd

vsim work.PC_REG_TB
add wave -position end sim:/*
radix -hexadecimal

run 100 ns