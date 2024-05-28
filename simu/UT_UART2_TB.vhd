library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UT_UART2_TB is
end UT_UART2_TB;

architecture TB of UT_UART2_TB is
    -- Instantiation du composant à tester
    component UT_UART2
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

            UART_in     :  IN STD_LOGIC_VECTOR(31 downto 0);
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
    signal UART_out, UART_in    : std_logic_vector(31 downto 0) := (others => '0');




begin
    -- Instance de l'UT
    reg_bench_inst: UT_UART2
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
            UART_in     => UART_in,
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

        -- - Lecture dans la mémoire
        RA <= x"0";
        RB <= x"1";
        RW <= x"1";
        Im <= x"10";
        COM_Mux_im <= '1';
        OP <= "000"; 
        COM_Mux_out <= '1'; 
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (B = x"00000048") report "Erreur de valeur sur reg 1" severity error;

        -- - Lecture dans l'UART
        UART_in <= x"00000042";
        RA <= x"0";
        RB <= x"2";
        RW <= x"2";
        Im <= x"41";
        COM_Mux_im <= '1';
        OP <= "000"; 
        COM_Mux_out <= '1'; 
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (B = x"00000042") report "Erreur de valeur sur reg 1" severity error;

        
        wait for 15 ns;
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
