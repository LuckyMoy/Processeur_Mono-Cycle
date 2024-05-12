library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity MUX is
    generic (
        N : integer := 32  -- Nombre de bits par défaut pour les vecteurs logiques
    );

    port (
        COM        : in std_logic;
        A            : in std_logic_vector((N-1) downto 0);
        B            : in std_logic_vector((N-1) downto 0);
        S            : out std_logic_vector((N-1) downto 0) -- registre de sortie su N bits
    );
end MUX;

architecture RTL of MUX is

    
begin

process(A, B, COM)

begin
    
    if COM = '0' then
        S <= A;
    else 
        S <= B;
    end if;


end process;

end RTL;
