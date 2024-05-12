library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG_BENCH_TB is
end REG_BENCH_TB;

architecture TB of REG_BENCH_TB is
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
            A      : out std_logic_vector(31 downto 0);
            B      : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signaux pour la simulation
    signal Clk   : std_logic := '0';
    signal Reset : std_logic;
    signal W     : std_logic_vector(31 downto 0);
    signal RA, RB, RW : std_logic_vector(3 downto 0) := (others => '0');
    signal WE    : std_logic := '0';
    signal A, B  : std_logic_vector(31 downto 0);

begin
    -- Instance du REG_BENCH
    uut: REG_BENCH
        port map (
            Clk    => Clk,
            Reset  => Reset,
            W      => W,
            RA     => RA,
            RB     => RB,
            RW     => RW,
            WE     => WE,
            A      => A,
            B      => B
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
        wait for 25 ns;
        RA <= "0000";
        RB <= "0001";
        Reset <= '0';
        wait for 10 ns;

        -- Test d'écriture
        W <= x"0000000F";  -- Valeur à écrire
        RW <= "0000";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        W <= x"000000FF";  -- Valeur à écrire
        RW <= "0001";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        W <= x"00000FFF";  -- Valeur à écrire
        RW <= "0010";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        W <= x"0000FFFF";  -- Valeur à écrire
        RW <= "0011";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        W <= x"000FFFFF";  -- Valeur à écrire
        RW <= "0100";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        W <= x"00FFFFFF";  -- Valeur à écrire
        RW <= "0101";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        W <= x"0FFFFFFF";  -- Valeur à écrire
        RW <= "0110";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        W <= x"FFFFFFFF";  -- Valeur à écrire
        RW <= "0111";  -- Adresse d'écriture
        WE <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WE <= '0';
        wait for 10 ns;

        -- Lecture pour vérification
        RA <= "0000";
        RB <= "0001";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"0000000F") report "Erreur de valeur sur A" severity error;
        assert (B = x"000000FF") report "Erreur de valeur sur B" severity error;
        

        RA <= "0010";
        RB <= "0011";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"00000FFF") report "Erreur de valeur sur A" severity error;
        assert (B = x"0000FFFF") report "Erreur de valeur sur B" severity error;
        

        RA <= "0100";
        RB <= "0101";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"000FFFFF") report "Erreur de valeur sur A" severity error;
        assert (B = x"00FFFFFF") report "Erreur de valeur sur B" severity error;
        

        RA <= "0110";
        RB <= "0111";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"0FFFFFFF") report "Erreur de valeur sur A" severity error;
        assert (B = x"FFFFFFFF") report "Erreur de valeur sur B" severity error;
        


        -- reset 
        Reset <= '1';  -- Activation de la réinitialisation
        wait for 10 ns;
        Reset <= '0';
        wait for 10 ns;

        -- Lecture pour vérification
        RA <= "0000";
        RB <= "0001";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"00000000") report "Erreur de valeur sur A" severity error;
        assert (B = x"00000000") report "Erreur de valeur sur B" severity error;
        

        RA <= "0010";
        RB <= "0011";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"00000000") report "Erreur de valeur sur A" severity error;
        assert (B = x"00000000") report "Erreur de valeur sur B" severity error;
        

        RA <= "0100";
        RB <= "0101";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"00000000") report "Erreur de valeur sur A" severity error;
        assert (B = x"00000000") report "Erreur de valeur sur B" severity error;
        

        RA <= "0110";
        RB <= "0111";
        wait for 10 ns;
        -- -- Assertions pour vérifier le fonctionnement
        assert (A = x"00000000") report "Erreur de valeur sur A" severity error;
        assert (B = x"00000000") report "Erreur de valeur sur B" severity error;
        

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
