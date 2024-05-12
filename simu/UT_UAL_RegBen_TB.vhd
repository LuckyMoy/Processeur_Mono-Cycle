library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UT_TB is
end UT_TB;

architecture TB of UT_TB is
    -- Instantiation du composant à tester
    component REG_BENCH
        port (
            Clk    : in  std_logic;
            Reset  : in  std_logic;
            W      : in  std_logic_vector(31 downto 0);
            RA     : in  std_logic_vector(3 downto 0);
            RB     : in  std_logic_vector(3 downto 0);
            RW     : in  std_logic_vector(3 downto 0);
            WE     : in  std_logic;
            W_out        : out std_logic_vector(31 downto 0);
            A      : out std_logic_vector(31 downto 0);
            B      : out std_logic_vector(31 downto 0)
        );
    end component;

    component UAL
        port (
            Reset  : in std_logic;
            OP     : in std_logic_vector(2 downto 0);
            A      : in std_logic_vector(31 downto 0);
            B      : in std_logic_vector(31 downto 0);
            S      : out std_logic_vector(31 downto 0);
            N, Z, C, V : out std_logic
        );
    end component;

    type table is array (0 to 15) of std_logic_vector(31 downto 0);

    -- Signaux pour la simulation
    -- RB
    signal Clk   : std_logic := '0';
    signal Reset : std_logic;
    signal RA, RB, RW : std_logic_vector(3 downto 0) := (others => '0');
    signal WE    : std_logic := '0';
    signal W     : std_logic_vector(31 downto 0);
    signal W_out     : std_logic_vector(31 downto 0);
    signal A, B  : std_logic_vector(31 downto 0);
    
    -- UAL
    signal OP    : std_logic_vector(2 downto 0);
    signal N, Z, C, V : std_logic;


begin
    -- Instance du REG_BENCH
    reg_bench_uut: REG_BENCH
        port map (
            Clk    => Clk,
            Reset  => Reset,
            W      => W,
            RA     => RA,
            RB     => RB,
            RW     => RW,
            WE     => WE,
            W_out => W_out,
            A      => A,
            B      => B
        );


    ual_uut: UAL port map (
        Reset => Reset,
        OP => OP,
        A => A,
        B => B,
        S => W,
        N => N,
        Z => Z,
        C => C,
        V => V
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

    -- alias Banc_ext : table is << signal reg_bench_uut.Banc : table >>;

    -- Scénario de test
    Test_proc : process
    begin
        -- Initialisation
        Reset <= '1';  -- Activation de la réinitialisation
        wait for 15 ns;
        RA <= "0000";
        RB <= "0001";
        Reset <= '0';
        wait for 10 ns;

        -- R(1) = R(15)
        RW <= "0001";
        RA <= "1111";
        OP <= "011";
        WE <= '1';
        wait for 10 ns;
        WE <= '0';
        wait for 10 ns;


        -- R(1) = R(1) + R(15)
        RW <= "0001";
        RA <= "0001";
        RB <= "1111";
        OP <= "000";
        WE <= '1';
        wait for 10 ns;
        WE <= '0';
        wait for 10 ns;


        -- R(2) = R(1) + R(15)
        RW <= "0010";
        RA <= "0001";
        RB <= "1111";
        OP <= "000";
        WE <= '1';
        wait for 10 ns;
        WE <= '0';
        wait for 10 ns;


        -- R(3) = R(1) – R(15)
        RW <= "0011";
        RA <= "0001";
        RB <= "1111";
        OP <= "010";
        WE <= '1';
        wait for 10 ns;
        WE <= '0';
        wait for 10 ns;


        -- R(5) = R(7) – R(15)
        RW <= "0101";
        RA <= "0111";
        RB <= "1111";
        OP <= "010";
        WE <= '1';
        wait for 10 ns;
        WE <= '0';
        wait for 30 ns;

        -- Lecture pour vérification
        RA <= "0001";
        RB <= "0010";
        wait for 2 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"00000060") report "Erreur de valeur sur reg 1" severity error;
        assert (B = x"00000090") report "Erreur de valeur sur reg 2" severity error;

        RA <= "0011";
        RB <= "0101";
        wait for 2 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"00000030") report "Erreur de valeur sur reg 3" severity error;
        assert (B = x"FFFFFFD0") report "Erreur de valeur sur reg 5" severity error;
        
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
