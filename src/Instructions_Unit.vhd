LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY IU is
	PORT
	(
		Clk 	    :  IN  STD_LOGIC;
		Reset   	:  IN  STD_LOGIC;
		nPCsel   	:  IN  STD_LOGIC;

		Offset   	:  IN  STD_LOGIC_VECTOR(23 downto 0);
        Instruction :  OUT STD_LOGIC_VECTOR(31 downto 0)

	);
END entity;

ARCHITECTURE RTL OF IU IS 

    component INSTRUCTION_MEMORY
        port(
            PC:             in std_logic_vector (31 downto 0);
            Instruction:    out std_logic_vector (31 downto 0)
        );
    end component;

    component PC_UPDATE_UNIT
        port(
            Clk :       in STD_LOGIC;
            Reset :     in STD_LOGIC;
            nPCsel :    in STD_LOGIC;
            Offset:     in std_logic_vector (23 downto 0);
            PC :        out std_logic_vector (31 downto 0)
        );
    end component;

	-- Signaux

    signal Addr : std_logic_vector (31 downto 0);

BEGIN 

    PcUU_inst: PC_UPDATE_UNIT
    port map(
        Clk     => Clk,
        Reset   => Reset,
        nPCsel  => nPCsel,
        Offset  => Offset,
        PC      => Addr
    );

    IM_inst: INSTRUCTION_MEMORY
    port map(
        PC          => Addr,
        Instruction => Instruction
    );
    

END architecture;