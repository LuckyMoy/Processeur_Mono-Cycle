vlib work

vcom -2008 ../src/reg32.vhd
vcom -2008 REG32_TB.vhd

vsim work.REG32_TB
add wave -position end sim:/*
radix -hexadecimal

run 100 ns