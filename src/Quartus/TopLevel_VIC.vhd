LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel_VIC IS
    PORT (
        CLOCK_50   : IN STD_LOGIC;
        KEY        : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        SW        : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        HEX0       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX1       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX2       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX3       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX4       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX5       : OUT STD_LOGIC_VECTOR(0 to 6)
    );
END TopLevel_VIC;

ARCHITECTURE RTL OF TopLevel_VIC IS
    SIGNAL Rst             : STD_LOGIC;
    SIGNAL pol    : STD_LOGIC; 
    SIGNAL IRQ0, IRQ1    : STD_LOGIC; 
    SIGNAL RegAff_out: STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    Rst <= SW(0);
    IRQ0 <= NOT KEY(0);
    IRQ1 <= NOT KEY(1);
    pol <= '0';

    -- Instances of SEVEN_SEG
    SEVEN_SEG_inst0: ENTITY work.SEVEN_SEG
    PORT MAP (
        Data   => RegAff_out(3 downto 0),
        Pol    => pol,
        Segout => HEX0
    );

    SEVEN_SEG_inst1: ENTITY work.SEVEN_SEG
    PORT MAP (
        Data   => RegAff_out(7 downto 4),
        Pol    => pol,
        Segout => HEX1
    );

    SEVEN_SEG_inst2: ENTITY work.SEVEN_SEG
    PORT MAP (
        Data   => RegAff_out(11 downto 8),
        Pol    => pol,
        Segout => HEX2
    );

    SEVEN_SEG_inst3: ENTITY work.SEVEN_SEG
    PORT MAP (
        Data   => RegAff_out(15 downto 12),
        Pol    => pol,
        Segout => HEX3
    );

    SEVEN_SEG_inst4: ENTITY work.SEVEN_SEG
    PORT MAP (
        Data   => RegAff_out(19 downto 16),
        Pol    => pol,
        Segout => HEX4
    );

    SEVEN_SEG_inst5: ENTITY work.SEVEN_SEG
    PORT MAP (
        Data   => RegAff_out(23 downto 20),
        Pol    => pol,
        Segout => HEX5
    );

    -- Instance du processeur
    inst_Proc: work.PROCESSOR_VIC
    port map(
        Clk => CLOCK_50,
        Reset => Rst,
        busA => open,
        busB => open,
        busW => open,
        IRQ0 => IRQ0,
        IRQ1 => IRQ1,
        Instruction => open,
        Afficheur => RegAff_out
    );

END RTL;
