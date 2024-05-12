vlib work
vcom -93 ../src/instruction_memory.vhd
vcom -93 instruction_memory_TB.vhd

vsim work.instruction_memory_TB
add wave *
radix -hexadecimal
run 110 ns