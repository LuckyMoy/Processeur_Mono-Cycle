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
        for i in 31 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        for i in 63 downto 54 loop
            result(i) := (others=>'0');
        end loop;
        -- Mémoire Chargée pour test
        result (32):=x"00000001";
        result (33):=x"00000100";
        result (34):=x"00000200";
        result (35):=x"00000200";
        result (36):=x"00080000";
        result (37):=x"00000000";
        result (38):=x"00000000";
        result (39):=x"00000000";
        result (40):=x"00000001";
        result (41):=x"00080000";

        -- "Hello World!"
        result (16):=x"00000048";
        result (17):=x"00000065";
        result (18):=x"0000006C";
        result (19):=x"0000006C";
        result (20):=x"0000006F";
        result (21):=x"00000020";
        result (22):=x"00000057";
        result (23):=x"0000006F";
        result (24):=x"00000072";
        result (25):=x"0000006C";
        result (26):=x"00000064";
        result (27):=x"00000021";
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
