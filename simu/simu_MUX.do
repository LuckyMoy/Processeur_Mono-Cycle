vlib work
vcom -93 ../src/MUX.vhd
vcom -93 MUX_TB.vhd

vsim work.MUX_TB
add wave -position end sim:/*
run 25 ns