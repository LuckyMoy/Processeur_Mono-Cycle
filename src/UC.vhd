library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity INSTRUCTION_DECODER is
    port(
        Clk, Reset:     in std_logic;
        Instruction:    in std_logic_vector (31 downto 0);
        Flags:          in std_logic_vector (3 downto 0);
        Rd, Rn, Rm:     out std_logic_vector (3 downto 0);
        Imm8 :          out std_logic_vector(7 downto 0);
        nPCsel:         out std_logic;
        RegWr:          out std_logic;
        RegSel          out std_logic;
        ALUsrc:         out std_logic;
        MemWr:          out std_logic;
        ALUCtr:         out std_logic_vector (2 downto 0);
        WrSrc:          out std_logic;
        RegAff:         out std_logic
    );
end entity;

architecture RTL of INSTRUCTION_DECODER is
    signal PSREn: std_logic := '0';
    signal PSR, Flags32 : std_logic_vector(31 downto 0) := (others => '0');

    component PSR_REG is
        port(
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            WrEn : in STD_LOGIC;
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0)
        );
    end component;

    component INSTRUCTION_DECODER is
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
    
    begin
        Rd <= Instruction(15 downto 12);
        Rn <= Instruction(19 downto 16);
        Rm <= Instruction(3 downto 0);
        Imm8 <= Instruction(7 downto 0);
        Flags32(31 downto 28) <= Flags;

        inst_reg : PSR_REG
        port map(
            Clk => Clk,
            Reset => Reset,
            WrEn => PSREn,
            E => Flags32,
            S => PSR
        );

        inst_ID: INSTRUCTION_DECODER
        port map(
            Instruction => Instruction,
            RegPSR      => PSR,
            nPCsel      => nPCsel,
            RegWr       => RegWr,
            RegSel      => RegSel,
            ALUsrc      => ALUsrc,
            MemWr       => MemWr,
            ALUCtr      => ALUCtr,
            PSREn       => PSREn,
            WrSrc       => WrSrc,
            RegAff      => RegAff
        );


end architecture;