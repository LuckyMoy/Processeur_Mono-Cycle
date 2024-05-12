library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MUX_TB is
end MUX_TB;

architecture TB of MUX_TB is
    -- Instantiation du composant à tester
    component MUX
        generic (
            N : integer := 32
        );
        port (
            COM  : in std_logic;
            A    : in std_logic_vector(N-1 downto 0);
            B    : in std_logic_vector(N-1 downto 0);
            S    : out std_logic_vector(N-1 downto 0)
        );
    end component;

    signal COM : std_logic;
    signal A, B, S : std_logic_vector(31 downto 0); 


begin
    -- Instance du MUX
    mux_inst : MUX
        generic map (
            N => 32  -- Spécifie que les vecteurs doivent être de 32 bits (facultatif : par défaut 32)
        )
        port map (
            COM => COM,
            A => A,
            B => B,
            S => S
        );

    -- Scénario de test
    Test_proc : process
    begin

        -- Test sur A
        A <= x"0000_0000";
        B <= x"FFFF_FFFF";
        COM <= '0';
        wait for 1 ns;

        -- -- Assertions pour vérifier le fonctionnement
        assert (S = x"0000_0000") report "Erreur de valeur sur S = A" severity error;
        wait for 5 ns;

        -- Changement de A
        A <= x"0000_FFFF";
        B <= x"FFFF_0000";
        wait for 1 ns;

        -- -- Assertions pour vérifier le fonctionnement
        assert (S = x"0000_FFFF") report "Erreur de valeur sur changement de A" severity error;
        wait for 5 ns;

        -- Test sur B
        A <= x"0000_0000";
        B <= x"FFFF_FFFF";
        COM <= '1';
        wait for 1 ns;

        -- -- Assertions pour vérifier le fonctionnement
        assert (S = x"FFFF_FFFF") report "Erreur de valeur sur S = B" severity error;
        wait for 5 ns;

        -- Changement sur B
        A <= x"0000_FFFF";
        B <= x"FFFF_0000";
        wait for 1 ns;

        -- -- Assertions pour vérifier le fonctionnement
        assert (S = x"FFFF_0000") report "Erreur de valeur sur changement de B" severity error;

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
