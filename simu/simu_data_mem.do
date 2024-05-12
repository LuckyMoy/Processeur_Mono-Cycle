vlib work

vcom -2008 ../src/data_mem.vhd
vcom -2008 data_mem_TB.vhd

vsim work.DATA_MEM_TB
add wave -position end sim:/*
radix -hexadecimal

run 380 ns
