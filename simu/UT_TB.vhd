library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UT_TB is
end UT_TB;

architecture TB of UT_TB is
    -- Instantiation du composant à tester
    component UT
        PORT (
            CLOCK_50 	:  IN  STD_LOGIC;
            Reset    	:  IN  STD_LOGIC;

            RegWr       :  IN  STD_LOGIC;
            RW, RA, RB  :  IN  STD_LOGIC_VECTOR(3 downto 0);

            COM_Mux_im 	:  IN  STD_LOGIC;
            COM_Mux_Reg :  IN  STD_LOGIC;
            COM_Mux_out :  IN  STD_LOGIC;

            OP          :  IN  STD_LOGIC_VECTOR(2 downto 0);

            Im          :  IN  STD_LOGIC_VECTOR(7 downto 0);

            WrEn        :  IN  STD_LOGIC;

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




begin
    -- Instance de l'UT
    reg_bench_inst: UT
        port map (
            CLOCK_50 	=> Clk,
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

        -- Chargement d'une valeur dans le registre 15
        -- R15 = 48
        RW <= "1111";
        -- RA <= "1111";
        -- RB <= "1111";
        Im <= x"30";
        COM_Mux_im <= '1';
        OP <= "001"; -- S = B
        COM_Mux_out <= '0';
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (W = x"00000030") report "Erreur de valeur sur reg 15 (chargement de valeur immediate)" severity error;

        -- - L’addition de 2 registres
        -- R1 = R15 + R15 : R1 = 48 + 48 = 96
        RW <= "0001";
        RA <= "1111";
        RB <= "1111";
        -- Im <= x"00";
        COM_Mux_im <= '0';
        OP <= "000";
        COM_Mux_out <= '0';
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (W = x"00000060") report "Erreur de valeur sur reg 6 (addition de registres)" severity error;

        -- - L’addition d’1 registre avec une valeur immédiate
        -- R2 = R1 + 4 : R2 = 96 + 4 = 100
        RW <= "0010";
        RA <= "0001";
        -- RB <= "0000";
        Im <= x"04";
        COM_Mux_im <= '1';
        OP <= "000";
        COM_Mux_out <= '0';
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (W = x"00000064") report "Erreur de valeur sur reg 2 (addition immediate)" severity error;

        -- - La soustraction de 2 registres
        -- R3 = R2 - R15 = 100 - 48 = 52
        RW <= "0011";
        RA <= "0010";
        RB <= "1111";
        -- Im <= x"00";
        COM_Mux_im <= '0';
        OP <= "010";
        COM_Mux_out <= '0';
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (W = x"00000034") report "Erreur de valeur sur reg 3 (soustraction de registres)" severity error;

        -- - La soustraction d’1 valeur immédiate à 1 registre
        -- R4 = R3 - 10 = 52 - 10 = 42
        RW <= "0100";
        RA <= "0011";
        -- RB <= "1111";
        Im <= x"0A";
        COM_Mux_im <= '1';
        OP <= "010";
        COM_Mux_out <= '0';
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (W = x"0000002A") report "Erreur de valeur sur reg 4 (soustraction immediate)" severity error;

        -- - La copie de la valeur d’un registre dans un autre registre
        -- R5 = R4 = 42
        RW <= "0101";
        RA <= "0100";
        -- RB <= "1111";
        -- Im <= x"00";
        COM_Mux_im <= '0';
        OP <= "011"; -- S = A
        COM_Mux_out <= '0';
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        -- Lecture pour vérification
        assert (W = x"0000002A") report "Erreur de valeur sur reg 5 (copie d'un registre dans un autre)" severity error;

        -- - L’écriture d’un registre dans un mot de la mémoire.
        -- M8 = R5 = 42
        -- RW <= "0001";
        -- RA <= "1111";
        RB <= "0101";
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
        assert (W = x"0000002A") report "Erreur de valeur sur ecriture (ecriture d'un mot en memoire)" severity error;

        -- - La lecture d’un mot de la mémoire dans un registre.
        -- R6 = M8 = 42
        RW <= "0110";
        -- RA <= "1111";
        -- RB <= "1111";
        Im <= x"08";
        COM_Mux_im <= '1';
        OP <= "001"; -- S = B
        COM_Mux_out <= '1';
        WE <= '1';
        WrEn <= '0';
        wait for 10 ns;
        WE <= '0';
        WrEn <= '0';
        wait for 10 ns;
        
        -- Lecture pour vérification
        assert (W = x"0000002A") report "Erreur de valeur sur reg 6 (lecture d'un mot en memoire)" severity error;

        -- RA <= "0011";
        -- RB <= "0101";
        -- wait for 2 ns;
        -- -- -- Assertions pour vérifier le fonctionnement
        -- assert (A = x"00000030") report "Erreur de valeur sur reg 3" severity error;
        -- assert (B = x"FFFFFFD0") report "Erreur de valeur sur reg 5" severity error;
        
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
