library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity DATA_MEM is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        DataIn       : in std_logic_vector(31 downto 0);
        DataOut      : out std_logic_vector(31 downto 0);
        Addr         : in std_logic_vector(5 downto 0);
        WrEn         : in std_logic
    );
end DATA_MEM;

architecture RTL of DATA_MEM is
    -- Declaration Type Tableau Memoire
    type table is array(63 downto 0) of std_logic_vector(31 downto 0);

    -- Fonction d'initialisation du Mem
    function init_Mem return table is
        variable result : table;
        begin
        for i in 63 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        return result;
    end;

    -- Déclaration et Initialisation du Mem de Registres 16x32 bits
    signal Mem: table:=init_Mem;


begin
    -- Lecture combinatoire et simultanée
    DataOut <= Mem(To_integer(Unsigned(Addr)));

    process(Clk, reset)
    begin
        if reset = '1' then
            Mem <= init_Mem;
        elsif rising_edge(Clk) then
            if WrEn = '1' then
                Mem(To_integer(Unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;
end RTL;