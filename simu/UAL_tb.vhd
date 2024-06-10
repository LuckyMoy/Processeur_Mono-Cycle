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
    signal Flags : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: UAL port map (
        Reset => Reset,
        OP => OP,
        A => A,
        B => B,
        S => S,
        N => Flags(3),
        Z => Flags(2),
        C => Flags(1),
        V => Flags(0)
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
        assert(S = x"0000000A") report "Erreur de valeur sur S : Addition simple" severity Error;
        assert(Flags = "0000") report "Erreur de valeur sur Flags : Addition simple" severity Error;

        -- test ADD : overflow
        OP <= "000";
        A <= x"7FFFFFFF";
        B <= x"00000001";
        wait for clk_period;
        assert(S = x"80000000") report "Erreur de valeur sur S : Addition overflow" severity Error;
        assert(Flags = "1001") report "Erreur de valeur sur Flags : Addition overflow" severity Error;

        -- test ADD : overflow
        OP <= "000";
        A <= x"FFFFFFFF";
        B <= x"00000001";
        wait for clk_period;
        assert(S = x"00000000") report "Erreur de valeur sur S : Addition carry" severity Error;
        assert(Flags = "0110") report "Erreur de valeur sur Flags : Addition carry" severity Error;

        -- pause
        A <= x"00000000";
        B <= x"00000000";
        wait for 5 ns;

        -- test SUB
        OP <= "010";
        A <= x"00000003";
        B <= x"00000004";
        wait for clk_period;
        assert(S = x"FFFFFFFF") report "Erreur de valeur sur S : soustraction" severity Error;
        assert(Flags = "1000") report "Erreur de valeur sur Flags : soustraction" severity Error;

        -- test SUB : Zero
        OP <= "010";
        A <= x"00000ABC";
        B <= x"00000ABC";
        wait for clk_period;
        assert(S = x"00000000") report "Erreur de valeur sur S : soustraction zero" severity Error;
        assert(Flags = "1000") report "Erreur de valeur sur Flags : soustraction zero" severity Error;

        -- pause
        A <= x"00000000";
        B <= x"00000000";
        wait for 5 ns;

        -- test S = A
        A <= x"0000FFFF";
        B <= x"FFFF0000";
        OP <= "011";
        wait for clk_period;
        assert(S = x"0000FFFF") report "Erreur de valeur sur S : S = A" severity Error;
        assert(Flags = "0000") report "Erreur de valeur sur Flags : S = A" severity Error;
        
        -- test S = B
        OP <= "001";
        wait for clk_period;
        assert(S = x"FFFF0000") report "Erreur de valeur sur S : S = B" severity Error;
        assert(Flags = "1000") report "Erreur de valeur sur Flags : S = B" severity Error;

        -- pause
        A <= x"00000000";
        B <= x"00000000";
        wait for 5 ns;

        -- test OR
        OP <= "100";
        A <= x"0000FFFF";
        B <= x"00FFFF00";
        wait for clk_period;
        assert(S = x"00FFFFFF") report "Erreur de valeur sur S : or" severity Error;
        assert(Flags = "0000") report "Erreur de valeur sur Flags : or" severity Error;

        -- test AND
        OP <= "101";
        wait for clk_period;
        assert(S = x"0000FF00") report "Erreur de valeur sur S : and" severity Error;
        assert(Flags = "0000") report "Erreur de valeur sur Flags : and" severity Error;

        -- test XOR
        OP <= "110";
        wait for clk_period;
        assert(S = x"00FF00FF") report "Erreur de valeur sur S : xor" severity Error;
        assert(Flags = "0000") report "Erreur de valeur sur Flags : xor" severity Error;

        -- test NOT A
        OP <= "111";
        wait for clk_period;
        assert(S = x"FFFF0000") report "Erreur de valeur sur S : not A" severity Error;
        assert(Flags = "1000") report "Erreur de valeur sur Flags : not A" severity Error;

        -- Finish simulation 
        wait;

    end process;
end tb;
