library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity SIGN_EXT is
    generic (
        N : integer := 32  -- Nombre de bits par défaut pour les vecteurs logiques
    );

    port (
        E            : in std_logic_vector((N-1) downto 0);
        S            : out std_logic_vector(31 downto 0) -- registre de sortie su N bits
    );
end SIGN_EXT;

architecture RTL of SIGN_EXT is

    
begin

process(E)

begin
    
    S(31 downto N) <= (others => E(N-1));
    S((N-1) downto 0) <= E;


end process;

end RTL;
