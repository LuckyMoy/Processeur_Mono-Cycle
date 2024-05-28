LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY IU_UART is
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
END entity;

ARCHITECTURE RTL OF IU_UART IS 

    component instruction_memory_UART1
        port(
            PC:             in std_logic_vector (31 downto 0);
            Instruction:    out std_logic_vector (31 downto 0)
        );
    end component;

    component PC_UPDATE_UNIT_VIC
        port(
            Clk :       in STD_LOGIC;
            Reset :     in STD_LOGIC;
            nPCsel :    in STD_LOGIC;
            Offset:     in std_logic_vector (23 downto 0);
            LRen :      in STD_LOGIC;
            VICPC:      in std_logic_vector (31 downto 0);
            IRQ :       in STD_LOGIC;
            IRQ_END :   in STD_LOGIC;

            PC :        out std_logic_vector (31 downto 0);
            IRQ_SERV :  out STD_LOGIC
        );
    end component;

	-- Signaux

    signal Addr : std_logic_vector (31 downto 0);

BEGIN 

    PcUU_inst: PC_UPDATE_UNIT_VIC
    port map(
        Clk     => Clk,
        Reset   => Reset,
        nPCsel  => nPCsel,
        Offset  => Offset,
        PC      => Addr,
        IRQ     => IRQ,
        LRen    => LRen,
        VICPC   => VICPC,
        IRQ_END => IRQ_END,
        IRQ_SERV=> IRQ_SERV
    );

    IM_inst: instruction_memory_UART1
    port map(
        PC          => Addr,
        Instruction => Instruction
    );
    

END architecture;