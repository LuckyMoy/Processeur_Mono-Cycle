library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX is
    port (
        Clk          : in  std_logic;
        Reset        : in  std_logic;
        Rx           : in  std_logic;
        Tick         : in  std_logic;
        Clear_fdiv   : out std_logic;
        RxDone       : out std_logic;
        RxError      : out std_logic;
        Test         : out std_logic_vector(1 downto 0);
        Data         : out std_logic_vector(7 downto 0);               
        Parity       : in std_logic;               
        Even         : in std_logic
    );
end UART_RX;

architecture RTL of UART_RX is
    signal BitCounter : integer range 0 to 7;
    signal ShiftReg : std_logic_vector(7 downto 0);
    signal State_v : std_logic_vector(1 downto 0) := "00";

begin

    process (Clk, Reset)
    begin
        if Reset = '1' then
            Clear_fdiv <= '0';
            RxDone <= '0';
            RxError <= '0';
            Data <= (others => '0');
            BitCounter <= 0;
            ShiftReg <= (others => '1');
            State_v <= "00";
        elsif rising_edge(Clk) then

            if State_v = "00" then
                RxDone <= '0'; 
                if Rx = '0' then  
                    State_v <= "01";
                    Clear_fdiv <= '1';  
                end if;

            elsif State_v = "01" then
                Clear_fdiv <= '0';  
                if Tick = '1' then
                    ShiftReg <= (others => '0');
                    State_v <= "10";
                    BitCounter <= 0;
                end if;

            elsif State_v = "10" then
                if Tick = '1' then
                    ShiftReg(BitCounter) <= Rx;  
                    if BitCounter < 7 then
                        BitCounter <= BitCounter + 1;
                    else
                        BitCounter <= 0;
                        State_v <= "11";
                            
                    end if;
                end if;

                

            elsif State_v = "11" then
                    
                if Tick = '1' then
                    if Rx = '1' then  
                        Data <= ShiftReg;
                        RxDone <= '1';  
                    else
                        RxDone <= '1';  
                        RxError <= '1';
                    end if;
                    State_v <= "00";
                end if;
                
            end if;
        end if;
    end process;

end RTL;
