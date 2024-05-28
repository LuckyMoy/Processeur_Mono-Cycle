library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_memory_UART2 is
    port(
        PC:             in std_logic_vector (31 downto 0);
        Instruction:    out std_logic_vector (31 downto 0)
    );
end entity;


architecture RTL of instruction_memory_UART2 is
    type RAM64x32 is array (0 to 63) of std_logic_vector (31 downto 0);

function init_mem return RAM64x32 is
    variable ram_block : RAM64x32;
begin
 -- PC -- INSTRUCTION -- COMMENTAIRE
    ram_block(0 ) := x"E3A01020"; -- _main : MOV R1,#0x20 ; --R1 <= 0x20
    ram_block(1 ) := x"E3A02000"; -- MOV R2,#0 ; --R2 <= 0
    ram_block(2 ) := x"E6110000"; -- _loop : LDR R0,0(R1) ; --R0 <= MEM[R1]
    ram_block(3 ) := x"E0822000"; -- ADD R2,R2,R0 ; --R2 <= R2 + R0
    ram_block(4 ) := x"E2811001"; -- ADD R1,R1,#1 ; --R1 <= R1 + 1
    ram_block(5 ) := x"E351002A"; -- CMP R1,0x1A ; --? R1 = 0x1A
    ram_block(6 ) := x"BAFFFFFB"; -- BLT loop ; --branchement à _loop si R1 inferieur a 0x1A
    ram_block(7 ) := x"E6012000"; -- STR R2,0(R1) ; --MEM[R1] <= R2
    ram_block(8 ) := x"EAFFFFF7"; -- BAL main ; --branchement à _main
    -- ISR 0 : interruption 0
    --sauvegarde du contexte
    ram_block(9 ) := x"E60F1000"; -- STR R1,0(R15) ; --MEM[R15] <= R1
    ram_block(10) := x"E28FF001"; -- ADD R15,R15,1 ; --R15 <= R15 + 1
    ram_block(11) := x"E60F3000"; -- STR R3,0(R15) ; --MEM[R15] <= R3
    --traitement
    ram_block(12) := x"E3A08008"; -- MOV R8,0x08 ; --R8 <= 0x08
    ram_block(13) := x"E3A07001"; -- MOV R7,0x01 ; --R7 <= 0x01
    ram_block(14) := x"E3A0A040"; -- MOV R10,0x40 ; --R10 <= 0x40
    ram_block(15) := x"E617900F"; -- LDR R9,15(R7) ; --R9 <= MEM[15(R7)]
    ram_block(16) := x"E60A9000"; -- STR R9,0(R10) ; --MEM[R10] <= R9
    ram_block(17) := x"E6087000"; -- STR R7,0(R8) ; --MEM[R8] <= R7
    -- restauration du contexte
    ram_block(18) := x"E61F3000"; -- LDR R3,0(R15) ; --R3 <= MEM[R15]
    ram_block(19) := x"E28FF0FF"; -- ADD R15,R15,-1 ; --R15 <= R15 - 1
    ram_block(20) := x"E61F1000"; -- LDR R1,0(R15) ; --R1 <= MEM[R15]
    ram_block(21) := x"EB000000"; -- BX ; -- instruction de fin d'interruption
    ram_block(22) := x"00000000";
    -- ISR1 : interruption 1
    --sauvegarde du contexte - R15 correspond au pointeur de pile
    ram_block(23) := x"E60F4000"; -- STR R4,0(R15) ; --MEM[R15] <= R4
    ram_block(24) := x"E28FF001"; -- ADD R15,R15,1 ; --R15 <= R15 + 1
    ram_block(25) := x"E60F5000"; -- STR R5,0(R15) ; --MEM[R15] <= R5
    --traitement
    ram_block(26) := x"E3A05020"; -- MOV R5,0x20 ; --R5 <= 0x20
    ram_block(27) := x"E6154000"; -- LDR R4,0(R5) ; --R4 <= MEM[R5]
    ram_block(28) := x"E2844001"; -- ADD R4,R4,2 ; --R4 <= R1 + 1
    ram_block(29) := x"E6054000"; -- STR R4,0(R5) ; --MEM[R5] <= R4
    -- restauration du contexte
    ram_block(30) := x"E61F5000";-- LDR R5,0(R15) ; --R5 <= MEM[R15]
    ram_block(31) := x"E28FF0FF"; -- ADD R15,R15,-1 ; --R15 <= R15 - 1
    ram_block(32) := x"E61F4000"; -- LDR R4,0(R15) ; --R4 <= MEM[R15]
    ram_block(33) := x"EB000000";-- BX ; -- instruction de fin d'interruption
    ram_block(34) := x"00000001";
    ram_block(35) := x"00000002";
    -- ISR_TX : interruption TX
    --sauvegarde du contexte - R15 correspond au pointeur de pile
    ram_block(36) := x"E60F4000"; -- STR R4,0(R15) ; --MEM[R15] <= R4
    ram_block(37) := x"E28FF001"; -- ADD R15,R15,1 ; --R15 <= R15 + 1
    ram_block(38) := x"E60F5000"; -- STR R5,0(R15) ; --MEM[R15] <= R5
    --traitement
    ram_block(39) := x"E3A08008"; -- MOV R8, 0x08
    ram_block(40) := x"E3A09040"; -- MOV R9, 0x40
    ram_block(41) := x"E6187000"; -- LDR R7, 0(R8)
    ram_block(42) := x"E357000C"; -- CMP R7, 0xC
    ram_block(43) := x"BA000001"; -- BLT -tx
    ram_block(44) := x"EA000003"; -- BAL -end
    ram_block(45) := x"E617A010"; -- -tx: LDR R10, 0x10(R7)
    ram_block(46) := x"E609A000"; -- STR R10, 0(R9)
    ram_block(47) := x"E2877001"; -- Addi R7, R7, 0x1
    ram_block(48) := x"E6087000"; -- - end : STR R7, 0(R8)
    -- restauration du contexte
    ram_block(49) := x"E61F5000";-- LDR R5,0(R15) ; --R5 <= MEM[R15]
    ram_block(50) := x"E28FF0FF"; -- ADD R15,R15,-1 ; --R15 <= R15 - 1
    ram_block(51) := x"E61F4000"; -- LDR R4,0(R15) ; --R4 <= MEM[R15]
    ram_block(52) := x"EB000000";-- BX ; -- instruction de fin d'interruption
    ram_block(53 to 63) := (others=> x"00000000");
    return ram_block;

end init_mem;

signal mem: RAM64x32 := init_mem;

begin

    Instruction <= mem(to_integer (unsigned (PC)));
end architecture;