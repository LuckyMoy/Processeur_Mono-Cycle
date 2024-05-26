# Effacer tous les fichiers de simulation précédents
vdel -all -lib work

vlib work

vcom -2008 ../src/instructions_decoder_VIC.vhd
vcom -2008 ../src/reg32.vhd
vcom -2008 instructions_decoder_VIC_TB.vhd

vsim work.INSTRUCTION_DECODER_VIC_TB
add wave -position end sim:/*

run 220 ns