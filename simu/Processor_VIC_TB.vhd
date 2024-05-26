library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PROCESSOR_VIC_TB is
end PROCESSOR_VIC_TB;

architecture TB of PROCESSOR_VIC_TB is
    -- Instantiation du composant à tester
    component PROCESSOR_VIC
        port(
            Clk, Reset:         in std_logic;
            IRQ0, IRQ1:         in std_logic;
            busA, busB, busW:   out std_logic_vector(31 downto 0); -- debug
            Instruction:        out std_logic_vector(31 downto 0); -- debug
            -- IRQ_p:              out std_logic; -- debug
            Afficheur:          out std_logic_vector(31 downto 0) 
        );
    end component;

    -- Signaux pour la simulation
    signal Clk              : std_logic := '0';
    signal Reset            : std_logic;
    signal IRQ0, IRQ1       : std_logic := '0';
    -- signal IRQ_p            : std_logic;
    signal Afficheur        : std_logic_vector(31 downto 0);
    signal busA, busB, busW : std_logic_vector(31 downto 0);
    signal Instruction      : std_logic_vector(31 downto 0);
    

begin
    -- Instance du PROCESSOR_VIC
    uut: PROCESSOR_VIC
        port map (
            Clk => Clk,
            Reset => Reset,
            busA => busA,
            busB => busB,
            busW => busW,
            IRQ0 => IRQ0,
            IRQ1 => IRQ1,
            Instruction => Instruction,
            -- IRQ_p => IRQ_p,
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

        wait for 100 ns;
        IRQ0 <= '1';
        wait for 200 ns;
        IRQ0 <= '0';

        wait for 1050 ns;
        assert(afficheur = x"00100502") report "Erreur de valeur sur registre afficheur, verrifier somme des mem reg 0X20 à 0x29" severity Error;

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
