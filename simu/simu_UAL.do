vlib work
vcom -93 ../src/UAL.vhd
vcom -93 UAL_tb.vhd

vsim work.UAL_tb
add wave -position end sim:/*
radix -hexadecimal
run 130 ns
