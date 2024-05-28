library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG32_TB is
end REG32_TB;

architecture TB of REG32_TB is
    -- Instantiation du composant à tester
    component REG32
        port(
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            WrEn : in STD_LOGIC;
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0)
        );
    end component;

    -- Signaux pour la simulation
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic;
    signal WrEn    : std_logic := '0';
    signal E, S   : std_logic_vector(31 downto 0);

begin
    -- Instance du REG32
    uut: REG32
        port map (
            Clk     => Clk,
            Reset   => Reset,
            WrEn    => WrEn,
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
        assert(S = x"00000000") report "Erreur de valeur sur S (0x00000000 attendu)" severity Error;

        WrEn <= '1';
        E <= x"FFFF0000";
        wait for 20 ns;
        WrEn <= '0';
        assert(S = x"FFFF0000") report "Erreur de valeur sur S (0xFFFF0000 attendu)" severity Error;


        wait for 20 ns;
        Reset <= '1';
        wait for 20 ns;
        assert(S = x"00000000") report "Erreur de valeur sur S (0x00000000 attendu)" severity Error;
        Reset <= '0';


       
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
