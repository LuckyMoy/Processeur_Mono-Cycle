LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel_UART3 IS
    PORT (
        CLOCK_50   : IN STD_LOGIC;
        KEY        : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        GPIO_0     : OUT STD_LOGIC;
        GPIO_1     : in STD_LOGIC;
        SW         : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        LEDR       : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        HEX0       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX1       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX2       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX3       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX4       : OUT STD_LOGIC_VECTOR(0 to 6);
        HEX5       : OUT STD_LOGIC_VECTOR(0 to 6)
    );
END TopLevel_UART3;

ARCHITECTURE RTL OF TopLevel_UART3 IS
    SIGNAL Rst             : STD_LOGIC;
    SIGNAL pol    : STD_LOGIC; 
    SIGNAL IRQ0, IRQ1    : STD_LOGIC; 
    SIGNAL RegAff_out: STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- UART
    SIGNAL UART_go, tick, tick_half, clear_FDIV, Tx, Rx, IRQ_TX, IRQ_RX    : STD_LOGIC; 
    SIGNAL UART_out, UART_in: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
BEGIN
    Rst <= SW(0);
    IRQ0 <= NOT KEY(0);
    IRQ1 <= NOT KEY(1);
    pol <= '0';
    GPIO_0 <= Tx;
    Rx <= GPIO_1;
    LEDR(7 downto 0) <= UART_out(7 downto 0);
    LEDR(8) <= IRQ_RX;

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
    inst_Proc: work.PROCESSOR_UART3
    port map(
        Clk => CLOCK_50,
        Reset => Rst,
        busA => open,
        busB => open,
        busW => open,
        IRQ0 => IRQ0,
        IRQ1 => IRQ1,
        IRQ_TX => IRQ_TX,
        IRQ_RX => IRQ_RX,
        Instruction => open,
        Afficheur => RegAff_out,
        UART_go => UART_go,
        UART_out => UART_out,
        UART_in => UART_in
    );

    -- Instance of FDIV component
  FDIV_inst: ENTITY work.FDIV
  PORT MAP (
    Clk         => CLOCK_50,
    Reset       => Rst,
    Tick        => tick,
	 Tick_half	=> open,
	 Bauds_rate  => SW(1)
    -- Connect other outputs if necessary
  );

    -- Instance of FDIV component for RX
  FDIV_inst_rx: ENTITY work.FDIV
  PORT MAP (
    Clk         => CLOCK_50,
    Reset       => Rst or clear_FDIV,
    Tick        => open,
	 Tick_half	=> tick_half,
	 Bauds_rate  => SW(1)
    -- Connect other outputs if necessary
  );

    -- Instance of tx component
    TX_inst: ENTITY work.uart_tx
    PORT MAP (
        Clk     => CLOCK_50,
        Reset     => rst,
        Go => UART_go,
        Data => UART_out(7 downto 0),
        Tick => tick,
        Tx => Tx,
        TxIrq => IRQ_TX,
        Parity 			=> '0',
        Even 			=> '0'
        -- Connect other outputs if necessary
    );

    RX_inst: ENTITY work.uart_rx
	PORT MAP (
		Clk     		=> CLOCK_50,
		Reset			=> rst,
		Rx          	=> Rx,
	  	Tick 			=> Tick_half,
		Clear_fdiv  	=> clear_FDIV,
		RxDone			=>  IRQ_RX,
		RxError			=>  LEDR(9),
		Data    		=> UART_in(7 downto 0),
		Parity 			=> '0',
		Even 			=> '0' 
	);

END RTL;