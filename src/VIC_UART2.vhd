library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VIC_UART2 is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        IRQ_SERV     : in std_logic;
        IRQ0, IRQ1   : in std_logic;
        IRQ_TX       : in std_logic;
        IRQ_RX       : in std_logic;

        IRQ          : out std_logic;
        VIC_PC       : out std_logic_vector(31 downto 0)
    );
end VIC_UART2;

architecture RTL of VIC_UART2 is

    signal IRQ0_last, IRQ1_last, IRQ_TX_last, IRQ_RX_last : std_logic := '0';

begin

    -- Detection de front montant pour IRQ0 et IRQ1
    process(Clk, Reset)
    variable IRQ0_memo, IRQ1_memo, IRQ_TX_memo, IRQ_RX_memo : std_logic := '0';
    begin
        if Reset = '1' then
            IRQ0_last <= '0';
            IRQ1_last <= '0';
            IRQ_TX_last <= '0';
            IRQ_RX_last <= '0';
            IRQ0_memo := '0';
            IRQ1_memo := '0';
            IRQ_TX_memo := '0';
            IRQ_RX_memo := '0';
            IRQ <= '0';
            VIC_PC <= (others => '0');

        elsif rising_edge(Clk) then
            -- Détection IRQ0
            if IRQ0 = '1' and IRQ0_last = '0' then
                IRQ0_memo := '1';
            end if;
            IRQ0_last <= IRQ0;

            -- Détection IRQ1
            if IRQ1 = '1' and IRQ1_last = '0' then
                IRQ1_memo := '1';
            end if;
            IRQ1_last <= IRQ1;

            -- Détection IRQ_RX
            if IRQ_RX = '1' and IRQ_RX_last = '0' then
                IRQ_RX_memo := '1';
            end if;
            IRQ_RX_last <= IRQ_RX;

            -- Détection IRQ_TX
            if IRQ_TX = '1' and IRQ_TX_last = '0' then
                IRQ_TX_memo := '1';
            end if;
            IRQ_TX_last <= IRQ_TX;

            -- Acquitement
            if IRQ_SERV = '1' then
                IRQ0_memo := '0';
                IRQ1_memo := '0';
                IRQ_TX_memo := '0';
                IRQ_RX_memo := '0';
            end if;

            -- Gestion de la valeur de VIC_PC et IRQ
            if IRQ_TX_memo = '1' then
                IRQ <= '1';
                VIC_PC <= x"00000024";
            elsif IRQ_RX_memo = '1' then
                IRQ <= '1';
                VIC_PC <= x"00000035";
            elsif IRQ0_memo = '1' then
                IRQ <= '1';
                VIC_PC <= x"00000009";
            elsif IRQ1_memo = '1' then
                IRQ <= '1';
                VIC_PC <= x"00000017";
            else
                IRQ <= '0';
                VIC_PC <= (others => '0');
            end if;

        end if;
    end process;

end RTL;
