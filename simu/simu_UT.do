vlib work
vcom -2008 ../src/UT.vhd
vcom -2008 ../src/UAL.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 ../src/sign_ext.vhd
vcom -2008 ../src/register_bench.vhd
vcom -2008 ../src/data_mem.vhd
vcom -2008 UT_TB.vhd

vsim work.UT_TB
add wave -position end sim:/*


# Configurer le radix en hexa pour chaque signal
radix -decimal 

run 200 ns
