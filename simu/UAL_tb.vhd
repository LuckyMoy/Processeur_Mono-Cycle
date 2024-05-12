library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UAL_tb is
end UAL_tb;

architecture tb of UAL_tb is
    component UAL
        port (
            Reset  : in std_logic;
            OP     : in std_logic_vector(2 downto 0);
            A      : in std_logic_vector(31 downto 0);
            B      : in std_logic_vector(31 downto 0);
            S      : out std_logic_vector(31 downto 0);
            N, Z, C, V : out std_logic
        );
    end component;

    signal Reset : std_logic := '1';
    signal OP    : std_logic_vector(2 downto 0);
    signal A, B  : std_logic_vector(31 downto 0);
    signal S     : std_logic_vector(31 downto 0);
    signal N, Z, C, V : std_logic;

    constant clk_period : time := 10 ns;

begin
    uut: UAL port map (
        Reset => Reset,
        OP => OP,
        A => A,
        B => B,
        S => S,
        N => N,
        Z => Z,
        C => C,
        V => V
    );


    stim_proc : process
    begin
        -- reset
        Reset <= '1';
        wait for 1 ns;
        Reset <= '0';
        wait for 1 ns;

        -- test ADD
        OP <= "000";
        A <= x"00000009";
        B <= x"00000001";
        wait for clk_period;

        -- test ADD : overflow
        OP <= "000";
        A <= x"7FFFFFFF";
        B <= x"00000001";
        wait for clk_period;

        -- test ADD : overflow
        OP <= "000";
        A <= x"FFFFFFFF";
        B <= x"00000001";
        wait for clk_period;

        -- pause
        A <= x"00000000";
        B <= x"00000000";
        wait for 5 ns;

        -- test SUB
        OP <= "010";
        A <= x"00000003";
        B <= x"00000004";
        wait for clk_period;

        -- test SUB : Zero
        OP <= "010";
        A <= x"00000ABC";
        B <= x"00000ABC";
        wait for clk_period;

        -- pause
        A <= x"00000000";
        B <= x"00000000";
        wait for 5 ns;

        -- test S = A
        A <= x"0000FFFF";
        B <= x"FFFF0000";
        OP <= "011";
        wait for clk_period;
        
        -- test S = B
        OP <= "001";
        wait for clk_period;

        -- pause
        A <= x"00000000";
        B <= x"00000000";
        wait for 5 ns;

        -- test OR
        OP <= "100";
        A <= x"0000FFFF";
        B <= x"00FFFF00";
        wait for clk_period;

        -- test AND
        OP <= "101";
        wait for clk_period;

        -- test XOR
        OP <= "110";
        wait for clk_period;

        -- test NOT
        OP <= "111";
        wait for clk_period;

        -- Finish simulation 
        wait;

    end process;
end tb;
