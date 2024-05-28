LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity FDIV is
    generic (
        BaudRateH : integer := 115_200;
        BaudRateL : integer := 9_600;
        ClockFrequency : integer := 50_000_000
    );
    port (
        Clk       : in std_logic;
        Reset     : in std_logic;
        Tick      : out std_logic;
        Tick_half : out std_logic;
        Bauds_rate: in std_logic -- 0: 9600 bauds, 1: 115200 bauds
    );
end FDIV;

architecture RTL of FDIV is
    signal countTo : integer;
begin
    process(Clk, Reset)
        variable counter : integer := 0;
    begin
        if Reset = '1' then
            counter := 0;
            Tick <= '0';
            Tick_half <= '0';
        elsif rising_edge(Clk) then
            if Bauds_rate = '1' then
                countTo <= ClockFrequency / BaudRateH - 1;
            else
                countTo <= ClockFrequency / BaudRateL - 1;
            end if;

            counter := counter + 1;

            if counter >= countTo then
                Tick <= '1';
                -- Tick_half <= '1';
                counter := 0;
            elsif counter = countTo / 2 then
                Tick_half <= '1';
            else
                Tick <= '0';
                Tick_half <= '0';
            end if;
        end if;
    end process;
end RTL;
