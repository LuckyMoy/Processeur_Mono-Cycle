library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory_TB is
end instruction_memory_TB;

architecture TB of instruction_memory_TB is
    -- Instantiation du composant à tester
    component instruction_memory
        port(
            PC: in std_logic_vector (31 downto 0);
            Instruction: out std_logic_vector (31 downto 0)
        );
    end component;

    -- Signaux pour la simulation

    signal PC     : std_logic_vector(31 downto 0) := (others => '0');
    signal Instruction     : std_logic_vector(31 downto 0);

begin
    -- Instance du instruction_memory
    uut: instruction_memory
        port map (
            PC => PC,
            Instruction => Instruction
        );


    -- Scénario de test
    Test_proc : process
    begin

        PC <= x"00000000";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000001";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000002";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000003";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000004";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000005";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000006";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000007";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000008";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"00000009";  -- Valeur à écrire
        wait for 10 ns;

        PC <= x"0000000A";  -- Valeur à écrire
        wait for 10 ns;

        
        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
