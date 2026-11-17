-- CRC (7,4) encoder, generator polynomial G(x) = x^3 + x + 1 (1011).
-- Systematic codeword: [D3 D2 D1 D0 C2 C1 C0].
library ieee;
use ieee.std_logic_1164.all;

entity crc74_encoder is
    port (
        data_in  : in  std_logic_vector(3 downto 0);
        code_out : out std_logic_vector(6 downto 0)
    );
end entity crc74_encoder;

architecture rtl of crc74_encoder is
    signal c2, c1, c0 : std_logic;
begin
    -- Remainder of (data_in & "000") divided by "1011" (modulo-2).
    c2 <= data_in(3) xor data_in(2) xor data_in(1);
    c1 <= data_in(2) xor data_in(1) xor data_in(0);
    c0 <= data_in(3) xor data_in(2) xor data_in(0);

    code_out <= data_in & c2 & c1 & c0;
end architecture rtl;
