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
        -- Mémoire Chargée pour test
        result (32):=x"00000008";
        result (33):=x"00000008";
        result (34):=x"00000008";
        result (35):=x"00000008";
        result (36):=x"00000030";
        result (37):=x"00000008";
        result (38):=x"00000008";
        result (39):=x"00000008";
        result (40):=x"00000008";
        result (41):=x"00000010";
        result (42):=x"00000020";
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
