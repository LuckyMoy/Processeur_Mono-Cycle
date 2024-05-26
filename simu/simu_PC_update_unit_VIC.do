vlib work

vcom -2008 ../src/PC_update_unit_VIC.vhd
vcom -2008 ../src/PC_reg.vhd
vcom -2008 ../src/reg32.vhd
vcom -2008 ../src/sign_ext.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 PC_update_unit_VIC_TB.vhd

vsim work.PC_UPDATE_UNIT_VIC_TB
add wave -position end sim:/*
radix -decimal

run 470 ns