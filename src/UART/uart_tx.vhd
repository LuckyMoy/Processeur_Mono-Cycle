library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_TX is
    port (
        Clk             : in std_logic;               
        Reset           : in std_logic;               
        Go              : in std_logic;               
        Parity          : in std_logic;               
        Even            : in std_logic;               
        Data            : in std_logic_vector(7 downto 0);  
        Tick            : in std_logic;               
        Tx              : out std_logic;               
        TxIrq           : out std_logic;               
        Tx_busy         : out std_logic               
    );
end entity;

architecture RTL of UART_TX is
    signal Bit_Index : integer range 0 to 7 := 0; 
    signal Data_Reg : std_logic_vector(7 downto 0) := (others => '0');  
    signal State_v : std_logic_vector(1 downto 0) := (others => '0');  

begin

    process (Clk)
    begin
        if Reset = '1' then  
            Tx <= '1';  
            Bit_Index <= 0;
            Tx_busy <= '0';
            State_v <= "00";
        elsif rising_edge(Clk) then
            
            if State_v = "00" then
                
                TxIrq <= '0';
                Tx_busy <= '0';
                Tx <= '1';
                if Go = '1' then  
                    Data_Reg <= Data;  
                    State_v <= "01";
                    Tx_busy <= '1';
                end if;

            elsif State_v = "01" then
                if Tick = '1' then  
                    Tx <= '0';  
                    State_v <= "10";
                end if;

            elsif State_v = "10" then
                if Tick = '1' then
                    Tx <= Data_Reg(Bit_Index);  
                    if Bit_Index < 7 then
                        Bit_Index <= Bit_Index + 1;
                    else
                        Bit_Index <= 0;
                        State_v <= "11";  
                    end if;
                end if;

            elsif State_v = "11" then
                if Tick = '1'  then
                    Tx <= '1';  
                    if Go = '0' then
                        TxIrq <= '1';
                        State_v <= "00"; 
                    end if;
                end if;

            end if;
        end if;
    end process;

end architecture RTL;
