library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VIC_UART_TB is
end VIC_UART_TB;

architecture TB of VIC_UART_TB is
    -- Instantiation du composant à tester
    component VIC_UART
            port (
            Clk          : in std_logic;
            Reset        : in std_logic;
            IRQ_SERV     : in std_logic;
            IRQ0, IRQ1   : in std_logic;
            IRQ_TX       : in std_logic;

            IRQ          : out std_logic;
            VIC_PC       : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signaux pour la simulation
    signal Clk          : std_logic := '0';
    signal Reset        : std_logic := '0';
    signal IRQ_SERV     : std_logic := '0';
    signal IRQ0, IRQ1   : std_logic := '0';
    signal IRQ_TX       : std_logic := '0';


    signal IRQ          : std_logic := '0';
    signal VIC_PC       : std_logic_vector(31 downto 0);

begin
    -- Instance du PC_REG
    uut: VIC_UART
        port map (
            Clk => Clk,
            Reset => Reset,
            IRQ_SERV => IRQ_SERV,
            IRQ0 => IRQ0,
            IRQ1 => IRQ1,
            IRQ_TX => IRQ_TX,
            IRQ => IRQ,
            VIC_PC => VIC_PC
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
        wait for 10 ns;

        --Etat initial
        assert (IRQ = '0') report "Etat initial: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000000") report "Etat initial: Erreur de valeur VICPC" severity error;
        wait for 20 ns;

        -- IRQ sur voie TX
        IRQ_TX <= '1';
        wait for 10 ns;
        assert (IRQ = '1') report "IRQ sur voie 0: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000024") report "IRQ sur voie 0: Erreur de valeur VICPC" severity error;
        
        -- fin IRQ sur voie TX
        IRQ_TX <= '0';
        wait for 10 ns;
        assert (IRQ = '1') report "fin IRQ sur voie 0: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000024") report "fin IRQ sur voie 0: Erreur de valeur VICPC" severity error;
        
        -- Acquitement
        IRQ_SERV <= '1';
        wait for 10 ns;
        IRQ_SERV <= '0';
        assert (IRQ = '0') report "Acquitement: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000000") report "Acquitement: Erreur de valeur VICPC" severity error;
        wait for 10 ns;


        --IRQ sur voie 1
        IRQ1 <= '1';
        wait for 20 ns;
        assert (IRQ = '1') report "IRQ sur voie 1: Erreur de valeur IRQ (expected 1)" severity error;
        assert (VIC_PC = x"00000017") report "IRQ sur voie 1: Erreur de valeur VICPC" severity error;
        
        -- IRQ sur voie 0 (priorité différé)
        IRQ0 <= '1';
        wait for 10 ns;
        assert (IRQ = '1') report "IRQ sur voie 0 (priorité différé): Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000009") report "IRQ sur voie 0 (priorité différé): Erreur de valeur VICPC" severity error;
        
        -- fin IRQs
        IRQ0 <= '0';
        IRQ1 <= '0';
        wait for 10 ns;
        assert (IRQ = '1') report "fin IRQs: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000009") report "fin IRQs: Erreur de valeur VICPC" severity error;
        
        -- Acquitement
        IRQ_SERV <= '1';
        wait for 10 ns;
        IRQ_SERV <= '0';
        assert (IRQ = '0') report "Acquitement: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000000") report "Acquitement: Erreur de valeur VICPC" severity error;
        wait for 10 ns;

        --IRQ sur voie 0 (priorité simultanée)
        IRQ1 <= '1';
        IRQ0 <= '1';
        wait for 10 ns;
        assert (IRQ = '1') report "IRQ sur voie 0 (priorité simultanée): Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000009") report "IRQ sur voie 0 (priorité simultanée): Erreur de valeur VICPC" severity error;
        
        -- fin IRQs
        IRQ0 <= '0';
        IRQ1 <= '0';
        wait for 10 ns;
        assert (IRQ = '1') report "fin IRQs: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000009") report "fin IRQs: Erreur de valeur VICPC" severity error;
        
        -- Acquitement
        IRQ_SERV <= '1';
        wait for 10 ns;
        IRQ_SERV <= '0';
        assert (IRQ = '0') report "Acquitement: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000000") report "Acquitement: Erreur de valeur VICPC" severity error;
        wait for 10 ns;


        --IRQ sur voie 0 FRONT MONTANT
        IRQ0 <= '1';
        wait for 10 ns;
        assert (IRQ = '1') report "IRQ sur voie 0 FRONT MONTANT: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000009") report "IRQ sur voie 0 FRONT MONTANT: Erreur de valeur VICPC" severity error;
        
        -- Acquitement
        wait for 10 ns;
        IRQ_SERV <= '1';
        wait for 10 ns;
        IRQ_SERV <= '0';
        assert (IRQ = '0') report "Acquitement: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000000") report "Acquitement: Erreur de valeur VICPC" severity error;
        wait for 20 ns;

        -- IRQ sur voie 0 FRONT DESCENDANT
        IRQ0 <= '0';
        wait for 10 ns;
        assert (IRQ = '0') report "IRQ sur voie 0 FRONT DESCENDANT: Erreur de valeur IRQ" severity error;
        assert (VIC_PC = x"00000000") report "IRQ sur voie 0 FRONT DESCENDANT: Erreur de valeur VICPC" severity error;
        

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
