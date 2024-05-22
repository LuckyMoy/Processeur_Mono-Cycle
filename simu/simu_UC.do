# Effacer tous les fichiers de simulation précédents
vdel -all -lib work

vlib work

vcom -2008 ../src/instructions_decoder.vhd
vcom -2008 ../src/reg32.vhd
vcom -2008 ../src/UC.vhd
vcom -2008 UC_TB.vhd

vsim work.UC_TB
add wave -position end sim:/*
radix -hexadecimal

run 200 ns