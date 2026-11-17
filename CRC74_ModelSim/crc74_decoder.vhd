-- CRC (7,4) decoder/checker for generator 1011.
-- This circuit detects errors but DOES NOT correct corrupted bits.
library ieee;
use ieee.std_logic_1164.all;

entity crc74_decoder is
    port (
        code_in  : in  std_logic_vector(6 downto 0);
        data_out : out std_logic_vector(3 downto 0);
        syndrome : out std_logic_vector(2 downto 0);
        error    : out std_logic
    );
end entity crc74_decoder;

architecture rtl of crc74_decoder is
    signal s2, s1, s0 : std_logic;
begin
    -- Remainder of code_in divided by "1011" (modulo-2).
    s2 <= code_in(6) xor code_in(5) xor code_in(4) xor code_in(2);
    s1 <= code_in(5) xor code_in(4) xor code_in(3) xor code_in(1);
    s0 <= code_in(6) xor code_in(5) xor code_in(3) xor code_in(0);

    syndrome <= s2 & s1 & s0;
    error    <= s2 or s1 or s0;
    -- Extract data only. Treat data_out as invalid whenever error = '1'.
    data_out <= code_in(6 downto 3);
end architecture rtl;
