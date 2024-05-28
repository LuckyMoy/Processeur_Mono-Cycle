library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_REG_TB is
end UART_REG_TB;

architecture TB of UART_REG_TB is
    -- Instantiation du composant à tester
    component REG_UART
        port(
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            WrEn : in STD_LOGIC;
            Addr : in std_logic_vector (31 downto 0);
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0);
            Go : out STD_LOGIC
        );
    end component;

    -- Signaux pour la simulation
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic;
    signal WrEn    : std_logic;
    signal Addr, E, S   : std_logic_vector(31 downto 0);
    signal Go    : std_logic;

begin
    -- Instance du REG_UART
    uut: REG_UART
        port map (
            Clk     => Clk,
            Reset   => Reset,
            WrEn    => WrEn,
            Addr    => Addr,
            E       => E,
            S       => S,
            Go      => Go
        );

    -- Générateur d'horloge
    Clk_process : process
    begin
        while true loop
            Clk <= '0';
            wait for 10 ns;
            Clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Scénario de test
    Test_proc : process
    begin

        Reset <= '1';
        wait for 15 ns;
        Reset <= '0';
        wait for 5 ns;

        WrEn <= '1';
        E <= x"0000FFFF";
        Addr <= x"00000041";
        wait for 20 ns;
        WrEn <= '0';
        wait for 20 ns;

        WrEn <= '1';
        E <= x"000000FF";
        Addr <= x"00000040";
        wait for 20 ns;
        WrEn <= '0';
        wait for 40 ns;

        Addr <= x"00000000";
        E <= x"FFFFFFFF";
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';


       
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
