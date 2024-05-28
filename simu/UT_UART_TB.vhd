library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UT_UART_TB is
end UT_UART_TB;

architecture TB of UT_UART_TB is
    -- Instantiation du composant à tester
    component UT_UART
        PORT (
            Clk 	:  IN  STD_LOGIC;
            Reset    	:  IN  STD_LOGIC;

            RegWr       :  IN  STD_LOGIC;
            RW, RA, RB  :  IN  STD_LOGIC_VECTOR(3 downto 0);

            COM_Mux_im 	:  IN  STD_LOGIC;
            COM_Mux_Reg :  IN  STD_LOGIC;
            COM_Mux_out :  IN  STD_LOGIC;

            OP          :  IN  STD_LOGIC_VECTOR(2 downto 0);

            Im          :  IN  STD_LOGIC_VECTOR(7 downto 0);

            WrEn        :  IN  STD_LOGIC;

            UART_out    :  OUT STD_LOGIC_VECTOR(31 downto 0);
            UART_go     :  OUT STD_LOGIC;

            busA, busB, busW : OUT STD_LOGIC_VECTOR(31 downto 0)

        );
    end component;



    -- Signaux pour la simulation
    -- RB
    signal Clk   : std_logic := '0';
    signal Reset : std_logic;
    
    -- Reg Bench
    signal RA, RB, RW : std_logic_vector(3 downto 0) := (others => '0');
    signal WE    : std_logic := '0';
    signal W     : std_logic_vector(31 downto 0);
    signal A, B  : std_logic_vector(31 downto 0);
    
    -- UAL
    signal OP    : std_logic_vector(2 downto 0) := "000";

    -- MUX
    signal COM_Mux_im, COM_Mux_out : std_logic := '0';

    -- Imm
    signal Im     : std_logic_vector(7 downto 0) := "00000000";

    -- Data
    signal WrEn    : std_logic := '0';

    -- UART
    signal UART_go    : std_logic := '0';
    signal UART_out    : std_logic_vector(31 downto 0);




begin
    -- Instance de l'UT
    reg_bench_inst: UT_UART
        port map (
            Clk 	=> Clk,
            Reset    	=> Reset,

            RegWr       => WE,
            RA          => RA,
            RB          => RB,
            RW          => RW,

            COM_Mux_im 	=> COM_Mux_im,
            COM_Mux_Reg => '0',
            COM_Mux_out	=> COM_Mux_out,

            OP          => OP,

            Im          => Im,

            WrEn        => WrEn,

            UART_out    => UART_out,
            UART_go     => UART_go,

            busA        => A,
            busB        => B,
            busW        => W
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
        -- Initialisation
        Reset <= '1';  -- Activation de la réinitialisation
        wait for 5 ns;
        Reset <= '0';
        wait for 20 ns;

        -- - L’écriture d’un registre dans un mot de la mémoire.
        RW <= x"F";
        Im <= x"08";
        COM_Mux_im <= '1';
        OP <= "001"; -- S = B
        COM_Mux_out <= '1'; -- useless
        WE <= '0';
        WrEn <= '1';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (W = x"00000030") report "Erreur de valeur sur ecriture (ecriture d'un mot en memoire)" severity error;
        assert (UART_out = x"00000000") report "Erreur de valeur sur UART_out" severity error;
        assert (UART_go = '0') report "Erreur de valeur sur UART_go" severity error;

        -- - L’écriture dans le registre UART.
        RW <= x"F";
        Im <= x"40";
        COM_Mux_im <= '1';
        OP <= "001"; -- S = B
        COM_Mux_out <= '1'; -- useless
        WE <= '0';
        WrEn <= '1';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (UART_out = x"00000030") report "Erreur de valeur sur UART_out" severity error;
        assert (UART_go = '1') report "Erreur de valeur sur UART_go" severity error;

        
        wait for 15 ns;
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
