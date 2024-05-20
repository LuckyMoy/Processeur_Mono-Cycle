library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRUCTION_DECODER_TB is
end INSTRUCTION_DECODER_TB;

architecture TB of INSTRUCTION_DECODER_TB is
    -- Instantiation du composant à tester
    component INSTRUCTION_DECODER
        port(
            Instruction:    in std_logic_vector (31 downto 0);
            RegPSR:         in std_logic_vector (31 downto 0);
            nPCsel:         out std_logic;
            RegWr:          out std_logic;
            RegSel:         out std_logic;
            ALUsrc:         out std_logic;
            MemWr:          out std_logic;
            ALUCtr:         out std_logic_vector (2 downto 0);
            PSREn:          out std_logic;
            WrSrc:          out std_logic;
            RegAff:         out std_logic
        );
    end component;



    -- Signaux pour la simulation
    signal Instruction     : std_logic_vector(31 downto 0);

    signal ALUCtr     : std_logic_vector(2 downto 0);
    signal nPCsel, RegWr, RegSel, ALUsrc, MemWr, WrSrc, RegAff, PSREn : std_logic;


begin
    -- Instance de l'INSTRUCTION_DECODER
    reg_bench_inst: INSTRUCTION_DECODER
        port map (
            Instruction => Instruction,
            RegPSR => (others => '0'),
            nPCsel => nPCsel,
            RegWr => RegWr,
            RegSel => RegSel,
            ALUsrc => ALUsrc,
            MemWr => MemWr,
            ALUCtr => ALUCtr,
            PSREn => PSREn,
            WrSrc => WrSrc,
            RegAff => RegAff
        );

    -- Scénario de test
    Test_proc : process
    begin
        -- Initialisation
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
