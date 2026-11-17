CRC (7,4) VHDL - ModelSim/QuestaSim
==================================
Generator: 1011 = x^3 + x + 1.
Inputs:  4-bit data_in.
Outputs: 7-bit code_out = data_in & CRC[2:0].
Decoder: code_in -> data_out, syndrome, error.

Run in ModelSim/QuestaSim (GUI):
1. Open ModelSim and change directory to this folder.
2. In the Transcript, type: do run.do
3. Inspect the Wave window and Transcript.

Or execute the commands individually:
  vlib work
  vmap work work
  vcom -2008 crc74_encoder.vhd
  vcom -2008 crc74_decoder.vhd
  vcom -2008 tb_crc74.vhd
  vsim work.tb_crc74
  add wave -radix binary sim:/tb_crc74/*
  run -all

Expected Transcript:
  # ** Note: PASS: 16 messages, 112 single-bit and 336 double-bit error tests.

CRC equations:
  C2 = D3 xor D2 xor D1
  C1 = D2 xor D1 xor D0
  C0 = D3 xor D2 xor D0

Decoder syndrome equations (R = received 7-bit word):
  S2 = R6 xor R5 xor R4 xor R2
  S1 = R5 xor R4 xor R3 xor R1
  S0 = R6 xor R5 xor R3 xor R0
  error = S2 or S1 or S0
  data_out = R6 & R5 & R4 & R3

Example:
  data_in  = 1101
  remainder = 001
  code_out = 1101001
  received = 1101001 -> syndrome = 000, error = 0
  received = 1101000 -> syndrome = 001, error = 1

IMPORTANT:
* If error=1, data_out is just a raw 4-bit extraction; it is NOT corrected.
* A zero syndrome means 'no error detected', NOT proof of no errors.
* Detects every single- and double-bit error in a 7-bit codeword.
* Some patterns of three or more flipped bits can go undetected.
* Encoder/decoder are asynchronous combinational logic: no clock needed.
* VHDL-2008 is needed for the 'std.env.stop' testbench terminator.
