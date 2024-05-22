library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PROCESSOR is
    port(
        Clk, Reset:         in std_logic;
        busA, busB, busW:   out std_logic_vector(31 downto 0); -- debug
        Instruction:        out std_logic_vector(31 downto 0); -- debug
        Afficheur:          out std_logic_vector(31 downto 0) 
    );
end entity;

architecture RTL of PROCESSOR is

    component UT is
        PORT (
            Clk 	:  IN  STD_LOGIC;
            Reset   	:  IN  STD_LOGIC;

            RegWr       :  IN  STD_LOGIC;
            RW, RA, RB  :  IN  STD_LOGIC_VECTOR(3 downto 0);

            COM_Mux_im 	:  IN  STD_LOGIC;
            COM_Mux_reg	:  IN  STD_LOGIC;
            COM_Mux_out :  IN  STD_LOGIC;

            OP          :  IN  STD_LOGIC_VECTOR(2 downto 0);

            Im          :  IN  STD_LOGIC_VECTOR(7 downto 0);

            WrEn        :  IN  STD_LOGIC;

            Flags       :  OUT STD_LOGIC_VECTOR(3 downto 0);

            busA, busB, busW : OUT STD_LOGIC_VECTOR(31 downto 0)

        );
    end component;

    component UC is
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

    component IU is
        PORT (
            Clk 	    :  IN  STD_LOGIC;
            Reset   	:  IN  STD_LOGIC;
            nPCsel   	:  IN  STD_LOGIC;

            Offset   	:  IN  STD_LOGIC_VECTOR(23 downto 0);
            Instruction :  OUT STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component REG32 is
        port(
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            WrEn : in STD_LOGIC;
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0)
        );
    end component;

    -- Signaux
    signal nPCsel, RegWr, RegSel, ALUSrc, WrSrc, MemWr, RegAff :    std_logic;
    signal Imm24  :                 std_logic_vector(23 downto 0);
    signal Imm8  :                  std_logic_vector(7 downto 0);
    signal ALUCtr         :         std_logic_vector(2 downto 0);
    signal Flags  :                 std_logic_vector(3 downto 0);
    signal Rd, Rn, RM  :            std_logic_vector(3 downto 0);
    signal Instruction_s, busB_s  : std_logic_vector(31 downto 0);
    
    begin
        busB <= busB_s;
        Instruction <= Instruction_s;

        inst_IU: IU
            port map(
                Clk => Clk,
                Reset => Reset,
                nPCsel => nPCsel,
                Offset => Imm24,
                Instruction => Instruction_s
            );

        inst_UT: UT
            port map(
                Clk => Clk,
                Reset => Reset,
                RegWr => RegWr,
                RW => Rd,
                RA => Rn,
                RB => Rm,
                COM_Mux_im => ALUSrc,
                COM_Mux_reg => RegSel,
                COM_Mux_out => WrSrc,
                OP => ALUCtr,
                Im => Imm8,
                WrEn => MemWr,
                Flags => Flags,
                busA => busA,
                busB => busB_s,
                busW => busW
            );

        inst_UC: UC
            port map(
                Clk => Clk,
                Reset => Reset,
                Instruction => Instruction_s,
                Flags => Flags,
                Rd => Rd,
                Rn => Rn,
                Rm => Rm,
                Imm8 => Imm8,
                Imm24 => Imm24,
                nPCsel => nPCsel,
                RegWr => RegWr,
                RegSel => RegSel,
                ALUsrc => ALUsrc,
                MemWr => MemWr,
                ALUCtr => ALUCtr,
                WrSrc => WrSrc,
                RegAff => RegAff
            );

        inst_reg_aff: REG32
            port map(
                Clk => Clk,
                Reset => Reset,
                WrEn => RegAff,
                E => busB_s,
                S => Afficheur
            );


end architecture;