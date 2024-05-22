library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity REG32 is
    port(
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        WrEn : in STD_LOGIC;
        E: in std_logic_vector (31 downto 0);
        S: out std_logic_vector (31 downto 0)
    );
end entity;

architecture RTL of REG32 is

    begin
        process(Clk, Reset)
        begin

        if Reset = '1' then
            S <= (others => '0');
        elsif rising_edge(Clk) and WrEn = '1' then
            S <= E;
        end if;

        end process;

end architecture;