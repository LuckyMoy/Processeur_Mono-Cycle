library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_REG_TB is
end PC_REG_TB;

architecture TB of PC_REG_TB is
    -- Instantiation du composant à tester
    component PC_REG
        port(
            Clk : STD_LOGIC;
            Reset : STD_LOGIC;
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0)
        );
    end component;

    -- Signaux pour la simulation
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic;
    signal E, S   : std_logic_vector(31 downto 0);

begin
    -- Instance du PC_REG
    uut: PC_REG
        port map (
            Clk     => Clk,
            Reset   => Reset,
            E       => E,
            S       => S
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

        E <= x"0000FFFF";
        wait for 20 ns;

        E <= x"FFFF0000";
        wait for 20 ns;

        E <= x"FFFFFFFF";
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';


       
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
