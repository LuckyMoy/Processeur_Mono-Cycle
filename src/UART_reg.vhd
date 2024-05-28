library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity REG_UART is
    port(
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        WrEn : in STD_LOGIC;
        Addr : in std_logic_vector (31 downto 0);
        E: in std_logic_vector (31 downto 0);
        S: out std_logic_vector (31 downto 0);
        Go : out STD_LOGIC
    );
end entity;

architecture RTL of REG_UART is

    begin
        process(Clk, Reset)
        begin

        if Reset = '1' then
            S <= (others => '0');
            Go <= '0';
        elsif rising_edge(Clk) then
            if addr = x"00000040" and WrEn = '1' then
                S <= E;
                Go <= '1';
            else
                Go <= '0';
            end if;

        end if;

        end process;

end architecture;