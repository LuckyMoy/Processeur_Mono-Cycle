library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PROCESSOR_TB is
end PROCESSOR_TB;

architecture TB of PROCESSOR_TB is
    -- Instantiation du composant à tester
    component PROCESSOR
        port(
            Clk, Reset:         in std_logic;
            busA, busB, busW:   out std_logic_vector(31 downto 0); -- debug
            Instruction:        out std_logic_vector(31 downto 0); -- debug
            Afficheur:          out std_logic_vector(31 downto 0) 
        );
    end component;

    -- Signaux pour la simulation
    signal Clk              : std_logic := '0';
    signal Reset            : std_logic;
    signal Afficheur        : std_logic_vector(31 downto 0);
    signal busA, busB, busW : std_logic_vector(31 downto 0);
    signal Instruction      : std_logic_vector(31 downto 0);
    

begin
    -- Instance du PROCESSOR
    uut: PROCESSOR
        port map (
            Clk => Clk,
            Reset => Reset,
            busA => busA,
            busB => busB,
            busW => busW,
            Instruction => Instruction,
            Afficheur => Afficheur
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

    stim_proc : process
    begin
    -- Scénario de test
        -- Initialisation
        Reset <= '1';  -- Activation de la réinitialisation
        wait for 1 ns;
        Reset <= '0';  -- Activation de la réinitialisation

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
