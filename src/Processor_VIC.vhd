library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PROCESSOR_VIC is
    port(
        Clk, Reset:         in std_logic;
        IRQ0, IRQ1:         in std_logic;
        busA, busB, busW:   out std_logic_vector(31 downto 0); -- debug
        Instruction:        out std_logic_vector(31 downto 0); -- debug
        -- IRQ_p:              out std_logic; -- debug
        Afficheur:          out std_logic_vector(31 downto 0) 
    );
end entity;

architecture RTL of PROCESSOR_VIC is

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

    component UC_VIC is
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
        RegAff:         out std_logic;
        LRen:           out std_logic;
        IRQ_END:        out std_logic
    );
    end component;

    component IU_VIC is
        PORT
        (
            Clk 	    :  IN  STD_LOGIC;
            Reset   	:  IN  STD_LOGIC;
            nPCsel   	:  IN  STD_LOGIC;
            LRen        :  in STD_LOGIC;
            VICPC       :  in std_logic_vector (31 downto 0);
            IRQ         :  in STD_LOGIC;
            IRQ_END     :  in STD_LOGIC;
            Offset   	:  IN  STD_LOGIC_VECTOR(23 downto 0);

            Instruction :  OUT STD_LOGIC_VECTOR(31 downto 0);
            IRQ_SERV    :  out STD_LOGIC

        );
    end component;

    component VIC is
        port (
            Clk          : in std_logic;
            Reset        : in std_logic;
            IRQ_SERV     : in std_logic;
            IRQ0, IRQ1   : in std_logic;

            IRQ          : out std_logic;
            VIC_PC       : out std_logic_vector(31 downto 0)
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
    signal nPCsel, RegWr, RegSel, ALUSrc, WrSrc, MemWr, RegAff, LRen :    std_logic;
    signal Imm24  :                 std_logic_vector(23 downto 0);
    signal Imm8  :                  std_logic_vector(7 downto 0);
    signal ALUCtr         :         std_logic_vector(2 downto 0);
    signal Flags  :                 std_logic_vector(3 downto 0);
    signal Rd, Rn, RM  :            std_logic_vector(3 downto 0);
    signal Instruction_s, busB_s  : std_logic_vector(31 downto 0);

    signal IRQ_END, IRQ, IRQ_SERV :    std_logic := '0';
    signal VICPC  : std_logic_vector(31 downto 0);
    
    begin
        busB <= busB_s;
        Instruction <= Instruction_s;
        -- IRQ_p <= IRQ;

        inst_VIC: VIC
            port map(
                Clk          => Clk,
                Reset        => Reset,
                IRQ_SERV     => IRQ_SERV,
                IRQ0         => IRQ0, 
                IRQ1         => IRQ1, 
                IRQ          => IRQ,
                VIC_PC       => VICPC
            );

        inst_IU: IU_VIC
            port map(
                Clk => Clk,
                Reset => Reset,
                nPCsel => nPCsel,
                Offset => Imm24,
                Instruction => Instruction_s,
                LRen => LRen,
                IRQ => IRQ,
                IRQ_END => IRQ_END,
                VICPC => VICPC,
                IRQ_SERV => IRQ_SERV
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

        inst_UC: UC_VIC
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
                RegAff => RegAff,
                LRen => LRen,
                IRQ_END => IRQ_END
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