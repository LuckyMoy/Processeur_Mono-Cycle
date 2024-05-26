library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VIC is
    port (
        Clk          : in std_logic;
        Reset        : in std_logic;
        IRQ_SERV     : in std_logic;
        IRQ0, IRQ1   : in std_logic;

        IRQ          : out std_logic;
        VIC_PC       : out std_logic_vector(31 downto 0)
    );
end VIC;

architecture RTL of VIC is

    signal IRQ0_last, IRQ1_last : std_logic := '0';

begin

    -- Detection de front montant pour IRQ0 et IRQ1
    process(Clk, Reset)
    variable IRQ0_memo, IRQ1_memo : std_logic := '0';
    begin
        if Reset = '1' then
            IRQ0_last <= '0';
            IRQ1_last <= '0';
            IRQ0_memo := '0';
            IRQ1_memo := '0';
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

            -- Acquitement
            if IRQ_SERV = '1' then
                IRQ0_memo := '0';
                IRQ1_memo := '0';
            end if;

            -- Gestion de la valeur de VIC_PC et IRQ
            if IRQ0_memo = '1' then
                IRQ <= '1';
                VIC_PC <= x"00000009";
            elsif IRQ1_memo = '1' then
                IRQ <= '1';
                VIC_PC <= x"00000015";
            else
                IRQ <= '0';
                VIC_PC <= (others => '0');
            end if;

        end if;
    end process;

end RTL;
