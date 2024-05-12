library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_UPDATE_UNIT_TB is
end PC_UPDATE_UNIT_TB;

architecture TB of PC_UPDATE_UNIT_TB is
    -- Instantiation du composant à tester
    component PC_UPDATE_UNIT
        port(
            Clk : in STD_LOGIC;
            Reset :  in STD_LOGIC;
            nPCsel : in STD_LOGIC;
            Offset: in std_logic_vector (23 downto 0);
            PC : out std_logic_vector (31 downto 0)
        );
    end component;

    -- Signaux pour la simulation
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic := '0';
    signal nPCsel    : std_logic := '0';
    signal Addr   : std_logic_vector(31 downto 0);
    signal Offset   : std_logic_vector(23 downto 0) := (others => '0');

begin
    -- Instance du PC_REG
    uut: PC_UPDATE_UNIT
        port map (
            Clk     => Clk,
            Reset   => Reset,
            nPCsel  => nPCsel,
            PC      => Addr,
            Offset  => Offset
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

        Reset <= '1';
        wait for 10 ns;
        Reset <= '0';
       
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
