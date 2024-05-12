vlib work
vcom -93 ../src/sign_ext.vhd
vcom -93 sign_ext_TB.vhd

vsim work.SIGN_EXT_TB
add wave *
run 15 ns