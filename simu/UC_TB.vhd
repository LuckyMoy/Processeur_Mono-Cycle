library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UC_TB is
end UC_TB;

architecture TB of UC_TB is
    -- Instantiation du composant à tester
    component UC
        port(
            Clk, Reset:     in std_logic;
            Instruction:    in std_logic_vector (31 downto 0);
            Flags:          in std_logic_vector (3 downto 0);
            Rd, Rn, Rm:     out std_logic_vector (3 downto 0);
            Imm8 :          out std_logic_vector(7 downto 0);
            Imm24 :          out std_logic_vector(23 downto 0);
            nPCsel:         out std_logic;
            RegWr:          out std_logic;
            RegSel:          out std_logic;
            ALUsrc:         out std_logic;
            MemWr:          out std_logic;
            ALUCtr:         out std_logic_vector (2 downto 0);
            WrSrc:          out std_logic;
            RegAff:         out std_logic
        );
    end component;



    -- Signaux pour la simulation
    signal Clk, Reset : std_logic;
    signal Instruction     : std_logic_vector(31 downto 0);
    signal Flags : std_logic_vector(3 downto 0) := (others => '1');
    signal Rd, Rn, Rm : std_logic_vector(3 downto 0);
    signal Imm8 : std_logic_vector(7 downto 0);
    signal Imm24 : std_logic_vector(23 downto 0);

    signal ALUCtr     : std_logic_vector(2 downto 0);
    signal nPCsel, RegWr, RegSel, ALUsrc, MemWr, WrSrc, RegAff : std_logic;


begin
    -- Instance de l'UC
    reg_bench_inst: UC
        port map (
            Clk => Clk,
            Reset => Reset,
            Instruction => Instruction,
            Flags => Flags,
            Rd => Rd,
            Rn => Rn,
            Rm => Rm,
            Imm8  => Imm8 ,
            Imm24  => Imm24 ,
            nPCsel => nPCsel,
            RegWr => RegWr,
            RegSel => RegSel,
            ALUsrc => ALUsrc,
            MemWr => MemWr,
            ALUCtr => ALUCtr,
            WrSrc => WrSrc,
            RegAff => RegAff
        );

    -- Générateur d'horloge
    Clk_process : process
    begin
        while true loop
            Clk <= '0';
            wait for 10 ns;
            Clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Scénario de test
    Test_proc : process
    begin

        -- Initialisation
        Reset <= '1';
        wait for 15 ns;
        Reset <= '0';
        wait for 5 ns;

        Instruction <= x"E3A01020";-- 0x0 _main -- MOV R1,#0x20 -- R1 = 0x20
        report "MOV R1,#0x20 -- R1 = 0x20";
        wait for 20 ns;
        
        Instruction <= x"E3A02000";-- 0x1 -- MOV R2,#0x00 -- R2 = 0
        report "MOV R2,#0x00 -- R2 = 0";
        wait for 20 ns;

        Instruction <= x"E6110000";-- 0x2 _loop -- LDR R0,0(R1) -- R0 = DATAMEM[R1]
        report "LDR R0,0(R1) -- R0 = DATAMEM[R1]";
        wait for 20 ns;

        Instruction <= x"E0822000";-- 0x3 -- ADD R2,R2,R0 -- R2 = R2 + R0
        report "ADD R2,R2,R0 -- R2 = R2 + R0";
        wait for 20 ns;

        Instruction <= x"E2811001";-- 0x4 -- ADD R1,R1,#1 -- R1 = R1 + 1
        report "ADD R1,R1,#1 -- R1 = R1 + 1";
        wait for 20 ns;

        Instruction <= x"E351002A";-- 0x5 -- CMP R1,0x2A -- Flag = R1-0x2A,si R1 <= 0x2A
        report "CMP R1,0x2A";
        wait for 20 ns;

        Instruction <= x"BAFFFFFB";-- 0x6 -- BLT loop -- PC =PC+1+(-5) si N = 1
        report "BLT loop";
        wait for 20 ns;

        Instruction <= x"E6012000";-- 0x7 -- STR R2,0(R1) -- DATAMEM[R1] = R2
        report "STR R2,0(R1)";
        wait for 20 ns;

        Instruction <= x"EAFFFFF7";-- 0x8 -- BAL main -- PC=PC+1+(-9)
        report "BAL main";
        wait for 20 ns;



        report "Fin des tests";

        -- Fin du test
        wait;
    end process;

end TB;
