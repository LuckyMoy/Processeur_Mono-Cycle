library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity REG_BENCH is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        W            : in std_logic_vector(31 downto 0);
        RA           : in std_logic_vector(3 downto 0);
        RB           : in std_logic_vector(3 downto 0);
        RW           : in std_logic_vector(3 downto 0);
        WE           : in std_logic;
        W_out        : out std_logic_vector(31 downto 0);
        A            : out std_logic_vector(31 downto 0);
        B            : out std_logic_vector(31 downto 0)
    );
end REG_BENCH;

architecture RTL of REG_BENCH is
    -- Declaration Type Tableau Memoire
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);

    -- Fonction d'initialisation du banc
    function init_banc return table is
        variable result : table;
        begin
        for i in 14 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        result(15):=X"00000030";
        return result;
    end;

    -- Déclaration et Initialisation du Banc de Registres 16x32 bits
    signal Banc: table:=init_banc;


begin
    A <= Banc(To_integer(Unsigned(RA)));
    B <= Banc(To_integer(Unsigned(RB)));
    W_out <= Banc(To_integer(Unsigned(RW)));

    process(Clk, reset)
    begin
        if reset = '1' then
            Banc <= init_banc;
        elsif rising_edge(Clk) then
            if WE = '1' then
                Banc(To_integer(Unsigned(RW))) <= W;
            end if;
        end if;
    end process;
end RTL;
