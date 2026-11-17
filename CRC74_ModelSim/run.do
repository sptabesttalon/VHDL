# Run from the CRC74_ModelSim directory in ModelSim/QuestaSim.
if {![file isdirectory work]} {
    vlib work
}
vmap work work
vcom -2008 crc74_encoder.vhd
vcom -2008 crc74_decoder.vhd
vcom -2008 tb_crc74.vhd
vsim work.tb_crc74
add wave -radix binary sim:/tb_crc74/data_in
add wave -radix binary sim:/tb_crc74/code_out
add wave -radix binary sim:/tb_crc74/code_in
add wave -radix binary sim:/tb_crc74/data_out
add wave -radix binary sim:/tb_crc74/syndrome
add wave sim:/tb_crc74/error
run -all
