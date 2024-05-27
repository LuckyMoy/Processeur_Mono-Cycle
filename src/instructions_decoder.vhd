library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity INSTRUCTION_DECODER is
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
end entity;

architecture RTL of INSTRUCTION_DECODER is
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, NONE);
    signal instr_courante: enum_instruction;

    
    begin
        process(Instruction)
        begin
            instr_courante <= NONE;
            case instruction(31 downto 20) is
                when x"E3A" =>
                    instr_courante <= MOV;

                when x"E28" =>
                    instr_courante <= ADDi;

                when x"E08" =>
                    instr_courante <= ADDr;

                when x"E35" =>
                    instr_courante <= CMP;

                when x"E61" =>
                    instr_courante <= LDR;

                when x"E60" =>
                    instr_courante <= STR;

                when others => null;
            end case;

            -- Cas des instructions de branchement
            case instruction(31 downto 24) is
                when x"EA" =>
                    instr_courante <= BAL;

                when x"BA" =>
                    instr_courante <= BLT;

                when others => null;
                
            end case;
        end process;

        process(instr_courante)
        begin
            case instr_courante is
                when NONE =>
                    nPCsel <= '0';
                    RegWr  <= '0';
                    RegSel <= '0'; 
                    ALUsrc <= '0';
                    MemWr  <= '0';
                    ALUCtr <= "000";
                    PSREn  <= '0';
                    WrSrc  <= '0';
                    RegAff <= '0';

                when MOV =>
                    nPCsel <= '0';
                    RegWr  <= '1';
                    RegSel <= '0'; 
                    ALUsrc <= Instruction(25); -- bit '#'
                    MemWr  <= '0';
                    ALUCtr <= "001";
                    PSREn  <= '0';
                    WrSrc  <= '0';
                    RegAff <= '0';

                when ADDi =>
                    nPCsel <= '0';
                    RegWr  <= '1';
                    RegSel <= '0';
                    ALUsrc <= '1';
                    MemWr  <= '0';
                    ALUCtr <= "000";
                    -- PSREn  <= '0';
                    PSREn  <= Instruction(20);
                    WrSrc  <= '0';
                    RegAff <= '0';

                when ADDr =>
                    nPCsel <= '0';
                    RegWr  <= '1';
                    RegSel <= '0';
                    ALUsrc <= '0';
                    MemWr  <= '0';
                    ALUCtr <= "000";
                    -- PSREn  <= '0';
                    PSREn  <= Instruction(20);
                    WrSrc  <= '0';
                    RegAff <= '0';

                when CMP =>
                    nPCsel <= '0';
                    RegWr  <= '0';
                    RegSel <= '0';
                    ALUsrc <= Instruction(25); -- bit '#'
                    MemWr  <= '0';
                    ALUCtr <= "010";
                    PSREn  <= '1';
                    WrSrc  <= '0';
                    RegAff <= '0';

                when LDR =>
                    nPCsel <= '0';
                    RegWr  <= '1';
                    RegSel <= '1';
                    ALUsrc <= '1';
                    -- ALUsrc <= Instruction(25); -- bit '#'
                    MemWr  <= '0';
                    ALUCtr <= "000";
                    -- if Instruction(25) = '1' then
                    --     ALUCtr <= "001";
                    -- else
                    --     ALUCtr <= "010";  
                    -- end if;
                    PSREn  <= '0';
                    WrSrc  <= '1';
                    RegAff <= '0';

                when STR =>
                    nPCsel <= '0';
                    RegWr  <= '0';
                    RegSel <= '1';
                    ALUsrc <= '1'; 
                    -- ALUsrc <= Instruction(25); -- bit '#'
                    MemWr  <= '1';
                    ALUCtr <= "000";
                    PSREn  <= '0';
                    WrSrc  <= '0';
                    RegAff <= '1';

                when BAL =>
                    nPCsel <= '1';
                    RegWr  <= '0';
                    RegSel <= '0';
                    ALUsrc <= '0';
                    MemWr  <= '0';
                    ALUCtr <= "000";
                    PSREn  <= '0';
                    WrSrc  <= '0';
                    RegAff <= '0';

                when BLT =>
                    nPCsel <= RegPSR(31);
                    RegWr  <= '0';
                    RegSel <= '0';
                    ALUsrc <= '0';
                    MemWr  <= '0';
                    ALUCtr <= "000";
                    PSREn  <= '0';
                    WrSrc  <= '0';
                    RegAff <= '0';
            end case;
        end process;

end architecture;