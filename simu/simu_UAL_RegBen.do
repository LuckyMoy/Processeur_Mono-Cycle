vlib work
vcom -2008 ../src/UAL.vhd
vcom -2008 ../src/register_bench.vhd
vcom -2008 UT_UAL_RegBen_TB.vhd

vsim work.UT_TB
add wave -position end sim:/*


# Configurer le radix en décimal pour chaque signal
radix -decimal 

run 150 ns
