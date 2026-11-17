-- Exhaustive simulation of all 16 payloads and all 1-/2-bit corruptions.
-- VHDL-2008 testbench for ModelSim/QuestaSim.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tb_crc74 is
end entity tb_crc74;

architecture sim of tb_crc74 is
    signal data_in  : std_logic_vector(3 downto 0) := (others => '0');
    signal code_out : std_logic_vector(6 downto 0);
    signal code_in  : std_logic_vector(6 downto 0) := (others => '0');
    signal data_out : std_logic_vector(3 downto 0);
    signal syndrome : std_logic_vector(2 downto 0);
    signal error    : std_logic;
begin
    uut_encoder : entity work.crc74_encoder(rtl)
        port map (
            data_in  => data_in,
            code_out => code_out
        );

    uut_decoder : entity work.crc74_decoder(rtl)
        port map (
            code_in  => code_in,
            data_out => data_out,
            syndrome => syndrome,
            error    => error
        );

    stimulus : process
        variable tx : std_logic_vector(6 downto 0);
        variable corrupted : std_logic_vector(6 downto 0);
    begin
        for d in 0 to 15 loop
            data_in <= std_logic_vector(to_unsigned(d, 4));
            wait for 10 ns;
            tx := code_out;

            -- Known reference: 1101 -> CRC 001 -> 1101001.
            if d = 13 then
                assert tx = "1101001"
                    report "Wrong CRC for data 1101 (expected 1101001)"
                    severity failure;
            end if;

            -- No injected error: check CRC and decoded payload.
            code_in <= tx;
            wait for 10 ns;
            assert (error = '0') and (syndrome = "000")
                report "Valid codeword was rejected"
                severity failure;
            assert data_out = data_in
                report "Decoded data does not match input"
                severity failure;

            -- Every possible single-bit error must be detected.
            for b in 0 to 6 loop
                corrupted := tx;
                corrupted(b) := not corrupted(b);
                code_in <= corrupted;
                wait for 10 ns;
                assert (error = '1') and (syndrome /= "000")
                    report "Single-bit error was NOT detected"
                    severity failure;
            end loop;

            -- This 7-bit code also detects every double-bit error.
            for b1 in 0 to 5 loop
                for b2 in b1 + 1 to 6 loop
                    corrupted := tx;
                    corrupted(b1) := not corrupted(b1);
                    corrupted(b2) := not corrupted(b2);
                    code_in <= corrupted;
                    wait for 10 ns;
                    assert (error = '1') and (syndrome /= "000")
                        report "Double-bit error was NOT detected"
                        severity failure;
                end loop;
            end loop;
        end loop;

        report "PASS: 16 messages, 112 single-bit and 336 double-bit error tests."
            severity note;
        stop;
        wait;
    end process stimulus;
end architecture sim;
