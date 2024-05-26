library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_UPDATE_UNIT_VIC_TB is
end PC_UPDATE_UNIT_VIC_TB;

architecture TB of PC_UPDATE_UNIT_VIC_TB is
    -- Instantiation du composant à tester
    component PC_UPDATE_UNIT_VIC
        port(
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            nPCsel : in STD_LOGIC;
            Offset: in std_logic_vector (23 downto 0);
            LRen : in STD_LOGIC;
            VICPC: in std_logic_vector (31 downto 0);
            IRQ : in STD_LOGIC;
            IRQ_END : in STD_LOGIC;

            PC : out std_logic_vector (31 downto 0);
            IRQ_SERV : out STD_LOGIC
        );
    end component;

    -- Signaux pour la simulation
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic := '0';
    signal nPCsel, LRen, IRQ, IRQ_END    : std_logic := '0';
    signal Offset   : std_logic_vector(23 downto 0) := (others => '0');
    signal VICPC   : std_logic_vector(31 downto 0):= (others => '0');
    signal Addr   : std_logic_vector(31 downto 0);
    signal IRQ_SERV   : std_logic;

begin
    -- Instance du PC_REG
    uut: PC_UPDATE_UNIT_VIC
        port map (
            Clk     => Clk,
            Reset   => Reset,
            nPCsel  => nPCsel,
            LRen    => LRen,
            IRQ     => IRQ,
            IRQ_END => IRQ_END,
            VICPC   => VICPC,
            PC      => Addr,
            Offset  => Offset,
            IRQ_SERV=> IRQ_SERV
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

        wait for 100 ns;

        Offset <= x"000005"; 
        nPCsel <= '1';
        wait for 20 ns;
        nPCsel <= '0';
        wait for 80 ns;

        Offset <= x"FFFFFB";  -- -5
        nPCsel <= '1';
        wait for 20 ns;
        nPCsel <= '0';
        wait for 20 ns;
        assert(Addr = x"0000000C") report "Erreur de valeur sur Addr (12 attendu)" severity Error;

        Reset <= '1';
        wait for 10 ns;
        Reset <= '0';
        assert(Addr = x"00000000") report "Erreur de valeur sur Addr (0 attendu)" severity Error;

        wait for 60 ns;

        -- Tests du VIC
        VICPC <= x"00000040";
        IRQ <= '1';
        wait for 1 ns;
        assert(Addr = x"00000040") report "Erreur de valeur sur Addr (64 attendu)" severity Error;
        wait for 19 ns;

        IRQ <= '0';
        wait for 31 ns;
        assert(Addr = x"00000042") report "Erreur de valeur sur Addr (66 attendu)" severity Error;
        wait for 19 ns;

        IRQ_END <= '1';
        wait for 20 ns;
        IRQ_END <= '0';
        assert(Addr = x"00000004") report "Erreur de valeur sur Addr (4 attendu)" severity Error;
        wait for 40 ns;
        assert(Addr = x"00000006") report "Erreur de valeur sur Addr (6 attendu)" severity Error;

       
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
