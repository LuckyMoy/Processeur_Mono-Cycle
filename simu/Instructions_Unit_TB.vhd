library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IU_TB is
end IU_TB;

architecture TB of IU_TB is
    -- Instantiation du composant à tester
    component IU
        PORT (
            Clk 	    :  IN  STD_LOGIC;
            Reset   	:  IN  STD_LOGIC;
            nPCsel   	:  IN  STD_LOGIC;

            Offset   	:  IN  STD_LOGIC_VECTOR(23 downto 0);
            Instruction : OUT STD_LOGIC_VECTOR(31 downto 0)

        );
    end component;

    -- Signaux pour la simulation
    signal Clk          : std_logic := '0';
    signal Reset        : std_logic := '1';
    signal nPCsel       : std_logic := '0';
    signal Offset       : std_logic_vector(23 downto 0) := (others => '0');
    signal Instruction  : std_logic_vector(31 downto 0);

begin
    -- Instance du PC_REG
    uut: IU
        port map (
            Clk         => Clk,
            Reset       => Reset,
            nPCsel      => nPCsel,
            Offset      => Offset,
            Instruction => Instruction
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
        assert (Instruction = x"E3A01020") report "Erreur de valeur Inst (Inst 0 attendue)" severity error;

        wait for 160 ns; -- On va jusqu'à l'instruction 8
        assert (Instruction = x"EAFFFFF7") report "Erreur de valeur Inst (Inst 8 attendue)" severity error;


        -- Retour à l'instruction 0
        Offset <= x"FFFFF7";  -- -9
        nPCsel <= '1';
        wait for 20 ns;
        nPCsel <= '0';     
        assert (Instruction = x"E3A01020") report "Erreur de valeur Inst (Inst 0 attendue)" severity error;


        wait for 80 ns; -- On va jusqu'à l'instruction 4
        assert (Instruction = x"E2811001") report "Erreur de valeur Inst (Inst 4 attendue)" severity error;

        -- Saut à l'instruction 7
        Offset <= x"000002"; 
        nPCsel <= '1';
        wait for 20 ns;
        nPCsel <= '0';
        assert (Instruction = x"E6012000") report "Erreur de valeur Inst (Inst 7 attendue)" severity error;

        -- On repart de 0
        wait for 20 ns;
        Reset <= '1';
        wait for 10 ns;
        Reset <= '0';
       
        report "Fin des tests";
        assert (Instruction = x"E3A01020") report "Erreur de valeur Inst (Inst 0 attendue)" severity error;

        -- Fin du test
        wait;
    end process;

end TB;
