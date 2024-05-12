library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SIGN_EXT_TB is
end SIGN_EXT_TB;

architecture TB of SIGN_EXT_TB is
    -- Instantiation du composant à tester
    component SIGN_EXT
        generic (
            N : integer := 32
        );
        port (
            E            : in std_logic_vector((N-1) downto 0);
            S            : out std_logic_vector(31 downto 0) -- registre de sortie su N bits
        );
    end component;

    signal E : std_logic_vector(15 downto 0); 
    signal S : std_logic_vector(31 downto 0); 


begin
    -- Instance du SIGN_EXT
    signe_ext_inst : SIGN_EXT
        generic map (
            N => 16  -- 16 bits en entrée
        )
        port map (
            E => E,
            S => S
        );

    -- Scénario de test
    Test_proc : process
    begin

        E <= x"0030"; -- 48
        wait for 1 ns;

        -- -- Assertions pour vérifier le fonctionnement
        assert (S = x"0000_0030") report "Erreur de valeur sur S" severity error;
        wait for 5 ns;

        E <= x"FFD0"; -- -48
        wait for 1 ns;

        -- -- Assertions pour vérifier le fonctionnement
        assert (S = x"FFFF_FFD0") report "Erreur de valeur sur S" severity error;
        wait for 5 ns;

        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
