library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PROCESSOR_UART3_TB is
end PROCESSOR_UART3_TB;

architecture TB of PROCESSOR_UART3_TB is
    -- Instantiation du composant à tester
    component PROCESSOR_UART3
        port(
            Clk, Reset:         in std_logic;
            IRQ0, IRQ1:   in std_logic;
            IRQ_TX, IRQ_RX:   in std_logic;
            UART_go:            out std_logic;
            UART_in:            in std_logic_vector(31 downto 0);
            UART_out:           out std_logic_vector(31 downto 0);
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
    signal IRQ_TX, IRQ_RX   : std_logic := '0';
    -- signal IRQ_p            : std_logic;
    signal Afficheur        : std_logic_vector(31 downto 0);
    signal busA, busB, busW : std_logic_vector(31 downto 0);
    signal Instruction      : std_logic_vector(31 downto 0);
    signal UART_in          : std_logic_vector(31 downto 0);
    signal UART_out         : std_logic_vector(31 downto 0);
    signal UART_go          : std_logic;
    

begin
    -- Instance du PROCESSOR_UART3
    uut: PROCESSOR_UART3
        port map (
            Clk => Clk,
            Reset => Reset,
            busA => busA,
            busB => busB,
            busW => busW,
            IRQ0 => IRQ0,
            IRQ1 => IRQ1,
            IRQ_TX => IRQ_TX,
            IRQ_RX => IRQ_RX,
            Instruction => Instruction,
            -- IRQ_p => IRQ_p,
            Afficheur => Afficheur,
            UART_go => UART_go,
            UART_in => UART_in,
            UART_out => UART_out
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

        wait for 1200 ns;
        UART_in <= x"00000042";
        IRQ_RX <= '1';


        

        wait for 1200 ns;
        assert(afficheur = x"00000001") report "Erreur de valeur sur registre afficheur, verrifier somme des mem reg 0X20 à 0x29" severity Error;

        wait for 1050 ns;
        assert(afficheur = x"00000042") report "Erreur de valeur sur registre afficheur, verrifier somme des mem reg 0X20 à 0x29" severity Error;

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
