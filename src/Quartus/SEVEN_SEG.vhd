-- SevenSeg.vhd
-- ------------------------------
--   squelette de l'encodeur sept segment
-- ------------------------------

--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SEVEN_SEG is
  port ( Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 9
         Pol    : in  std_logic;                    -- '0' if active LOW
         Segout : out std_logic_vector(1 to 7) );   -- Segments A, B, C, D, E, F, G
end entity SEVEN_SEG;

architecture COMB of SEVEN_SEG is
begin
  -- Process to determine output based on Data and Pol
  process(Data, Pol)
  variable seg_active_high : std_logic_vector(1 to 7);
  begin
    -- Determine segments for active-high configuration based on Data
    case Data is
      when "0000" => seg_active_high := "1111110"; -- 0
      when "0001" => seg_active_high := "0110000"; -- 1
      when "0010" => seg_active_high := "1101101"; -- 2
      when "0011" => seg_active_high := "1111001"; -- 3
      when "0100" => seg_active_high := "0110011"; -- 4
      when "0101" => seg_active_high := "1011011"; -- 5
      when "0110" => seg_active_high := "1011111"; -- 6
      when "0111" => seg_active_high := "1110000"; -- 7
      when "1000" => seg_active_high := "1111111"; -- 8
      when "1001" => seg_active_high := "1111011"; -- 9
      when "1010" => seg_active_high := "1110111"; -- A
      when "1011" => seg_active_high := "0011111"; -- B
      when "1100" => seg_active_high := "1001110"; -- C
      when "1101" => seg_active_high := "0111101"; -- D
      when "1110" => seg_active_high := "1001111"; -- E
      when "1111" => seg_active_high := "1000111"; -- F
      when others => seg_active_high := "0000000"; -- Off
    end case;

    -- Adjust for polarity
    if Pol = '1' then
      Segout <= seg_active_high;
    else
      Segout <= NOT(seg_active_high);
    end if;
  end process;
end architecture COMB;
