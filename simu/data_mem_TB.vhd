library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DATA_MEM_TB is
end DATA_MEM_TB;

architecture TB of DATA_MEM_TB is
    -- Instantiation du composant à tester
    component DATA_MEM
        port (
            Clk          : in std_logic;
            Reset        : in std_logic;
            DataIn       : in std_logic_vector(31 downto 0);
            DataOut      : out std_logic_vector(31 downto 0);
            Addr         : in std_logic_vector(5 downto 0);
            WrEn         : in std_logic
        );
    end component;

    -- Signaux pour la simulation
    signal Clk      : std_logic := '0';
    signal Reset    : std_logic;
    signal DataIn   : std_logic_vector(31 downto 0);
    signal DataOut  : std_logic_vector(31 downto 0);
    signal Addr     : std_logic_vector(5 downto 0) := (others => '0');
    signal WrEn     : std_logic := '0';

begin
    -- Instance du DATA_MEM
    uut: DATA_MEM
        port map (
            Clk     => Clk,
            Reset   => Reset,
            DataIn  => DataIn,
            DataOut => DataOut,
            Addr    => Addr,
            WrEn    => WrEn
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
        Addr <= "000000";
        Reset <= '0';
        wait for 10 ns;

        -- Test d'écriture
        DataIn <= x"0000000F";  -- Valeur à écrire
        Addr <= "000000";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        DataIn <= x"000000FF";  -- Valeur à écrire
        Addr <= "000001";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        DataIn <= x"00000FFF";  -- Valeur à écrire
        Addr <= "000010";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        DataIn <= x"0000FFFF";  -- Valeur à écrire
        Addr <= "000011";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        DataIn <= x"000FFFFF";  -- Valeur à écrire
        Addr <= "000100";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        DataIn <= x"00FFFFFF";  -- Valeur à écrire
        Addr <= "000101";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        DataIn <= x"0FFFFFFF";  -- Valeur à écrire
        Addr <= "000110";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        DataIn <= x"FFFFFFFF";  -- Valeur à écrire
        Addr <= "000111";  -- Adresse d'écriture
        WrEn <= '1';  -- Activation de l'écriture
        wait for 20 ns;
        WrEn <= '0';
        wait for 10 ns;

        -- Lecture pour vérification
        Addr <= "000000";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_000F") report "Erreur de valeur sur mot 0" severity error;

        Addr <= "000001";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_00FF") report "Erreur de valeur sur mot 1" severity error;
        
        Addr <= "000010";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0FFF") report "Erreur de valeur sur mot 2" severity error;

        Addr <= "000011";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_FFFF") report "Erreur de valeur sur mot 3" severity error;

        Addr <= "000100";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"000F_FFFF") report "Erreur de valeur sur mot 4" severity error;

        Addr <= "000101";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"00FF_FFFF") report "Erreur de valeur sur mot 5" severity error;

        Addr <= "000110";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0FFF_FFFF") report "Erreur de valeur sur mot 6" severity error;

        Addr <= "000111";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"FFFF_FFFF") report "Erreur de valeur sur mot 7" severity error;
        


        -- reset 
        Reset <= '1';  -- Activation de la réinitialisation
        wait for 10 ns;
        Reset <= '0';
        wait for 10 ns;

        -- Lecture pour vérification
        Addr <= "000000";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 0" severity error;

        Addr <= "000001";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 1" severity error;
        
        Addr <= "000010";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 2" severity error;

        Addr <= "000011";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 3" severity error;

        Addr <= "000100";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 4" severity error;

        Addr <= "000101";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 5" severity error;

        Addr <= "000110";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 6" severity error;

        Addr <= "000111";
        wait for 5 ns;
        -- -- Assertion pour vérifier le fonctionnement
        assert (DataOut = x"0000_0000") report "Erreur de valeur sur mot 7" severity error;

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
