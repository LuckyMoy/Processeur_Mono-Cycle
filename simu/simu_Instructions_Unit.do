# Effacer tous les fichiers de simulation précédents
vdel -all -lib work

vlib work

vcom -2008 ../src/Instructions_Unit.vhd
vcom -2008 ../src/instruction_memory.vhd
vcom -2008 ../src/PC_update_unit.vhd
vcom -2008 ../src/PC_reg.vhd
vcom -2008 ../src/sign_ext.vhd
vcom -2008 ../src/MUX.vhd
vcom -2008 Instructions_Unit_TB.vhd

vsim work.IU_TB
add wave -position end sim:/*
radix -hexadecimal

run 350 ns