library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity UAL is
    port (
        Reset        : in std_logic;
        OP           : in std_logic_vector(2 downto 0);
        A            : in std_logic_vector(31 downto 0);
        B            : in std_logic_vector(31 downto 0);
        S            : out std_logic_vector(31 downto 0); -- registre de sortie su 32 bits
        N, Z, C, V   : out std_logic -- drapeaux (neg, zero, carry, overflow)
    );
end UAL;

architecture RTL of UAL is

    
begin

process(OP, A, B, reset)
variable S_temp : std_logic_vector(31 downto 0) := (others => '0');
variable S_ext : signed(32 downto 0);
begin
    if reset = '1' then
        S <= (others => '0');
        S <= (others => '0');
        N <= '0';
        Z <= '0';
        C <= '0';
        V <= '0';

    else
        case OP is 
            when "000" => -- ADD
                -- extension à 32 bits
                S_ext := ('0' & signed(A)) + ('0' & signed(B));
                S_temp := std_logic_vector(S_ext(31 downto 0));
                C <= S_ext(32);
                -- Overflow
                V <= not(A(31) xor B(31)) and (A(31) xor S_ext(31));

            when "010" => -- SUB
                -- extension à 32 bits
                S_ext := ('0' & signed(A)) - ('0' & signed(B));
                S_temp := std_logic_vector(S_ext(31 downto 0));
                C <= not S_ext(32);  -- S_ext(32) est '1' si un emprunt a été nécessaire, donc on le nie pour l'interprétation d'absence d'emprunt
                -- Overflow 
                V <= (A(31) xor B(31)) and not(B(31) xor S_ext(31));

            when "001" => -- B :  Y = B
                S_temp := B;    
                C <= '0';
                V <= '0';

            when "011" => -- A :  Y = A
                S_temp:= A;   
                C <= '0';
                V <= '0';

            when "100" => -- OR
                S_temp := A or B;   
                C <= '0';
                V <= '0';

            when "101" => -- AND
                S_temp := A and B;    
                C <= '0';
                V <= '0';

            when "110" => -- XOR
                S_temp := A xor B;    
                C <= '0';
                V <= '0';

            when "111" => -- NOT
                S_temp := not A; 
                C <= '0';
                V <= '0';

            when others => 
                S_temp := (others => '0');
                N <= '0';
                Z <= '0';
                C <= '0';
                V <= '0';
        end case;

        -- Update the flags
        S <= S_temp;
        N <= S_temp(31);
        if S_temp = "00000000000000000000000000000000" then Z <= '1'; 
        else Z <= '0'; end if;
    end if;
end process;

end RTL;
