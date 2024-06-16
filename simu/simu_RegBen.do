vlib work

vcom -2008 ../src/register_bench.vhd
vcom -2008 Reg_Bench_TB.vhd

vsim work.REG_BENCH_TB
add wave -position end sim:/*
radix -hexadecimal

run 380 ns
