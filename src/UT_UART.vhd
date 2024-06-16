library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

ENTITY UT_UART is
	PORT
	(
		Clk 	    :  IN  STD_LOGIC;
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

        UART_out    :  OUT STD_LOGIC_VECTOR(31 downto 0);
        UART_go     :  OUT STD_LOGIC;

        busA, busB, busW : OUT STD_LOGIC_VECTOR(31 downto 0)

	);
END entity;

ARCHITECTURE RTL OF UT_UART IS 

    component REG_UART is
        port(
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            WrEn : in STD_LOGIC;
            Addr : in std_logic_vector (31 downto 0);
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0);
            Go : out STD_LOGIC
        );
    end component;

    component REG_BENCH
        port (
            Clk    : in  std_logic;
            Reset  : in  std_logic;
            W      : in  std_logic_vector(31 downto 0);
            RA     : in  std_logic_vector(3 downto 0);
            RB     : in  std_logic_vector(3 downto 0);
            RW     : in  std_logic_vector(3 downto 0);
            WE     : in  std_logic;
            A      : out std_logic_vector(31 downto 0);
            B      : out std_logic_vector(31 downto 0)
        );
    end component;

    component DATA_MEM
        port (
            Clk          : in std_logic;
            Reset        : in std_logic;
            DataIn       : in std_logic_vector(31 downto 0);
            DataOut      : out std_logic_vector(31 downto 0);
            Addr         : in std_logic_vector(5 downto 0);
            WrEn         : in std_logic
        );
    end component;

    component MUX
        generic (
            N : integer := 32
        );
        port (
            COM  : in std_logic;
            A    : in std_logic_vector(N-1 downto 0);
            B    : in std_logic_vector(N-1 downto 0);
            S    : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component SIGN_EXT
        generic (
            N : integer := 32
        );
        port (
            E            : in std_logic_vector((N-1) downto 0);
            S            : out std_logic_vector(31 downto 0) -- registre de sortie su N bits
        );
    end component;

    component UAL
        port (
            Reset  : in std_logic;
            OP     : in std_logic_vector(2 downto 0);
            A      : in std_logic_vector(31 downto 0);
            B      : in std_logic_vector(31 downto 0);
            S      : out std_logic_vector(31 downto 0);
            N, Z, C, V : out std_logic
        );
    end component;

    -- signal Reset : std_logic;
    
    -- Reg Bench
    -- signal RA, RB, RW   : std_logic_vector(3 downto 0) := (others => '0');
    signal WE           : std_logic := '0';
    signal W            : std_logic_vector(31 downto 0);
    signal A, B         : std_logic_vector(31 downto 0);
    
    -- UAL
    -- signal OP         : std_logic_vector(2 downto 0);
    signal ALUout     : std_logic_vector(31 downto 0);
    -- signal N, Z, C, V : std_logic;

    -- MUX
    -- signal COM_Mux_im, COM_Mux_out  : std_logic;
    signal MUX_Im_out              : std_logic_vector(31 downto 0);
    signal MUX_Reg_out             : std_logic_vector(3 downto 0);

    -- Imm
    -- signal Im       : std_logic_vector(7 downto 0);
    signal Im32     : std_logic_vector(31 downto 0);

    -- Data
    signal DataOut      : std_logic_vector(31 downto 0);
    signal Addr      : std_logic_vector(5 downto 0);
    signal inf40      : std_logic;
    -- signal WrEn         : std_logic := '0';

BEGIN 

    WE <= RegWr;
    busA <= A;
    busB <= B;
    busW <= W;

    -- Instance du REG_UART
    inst_REG_UART: REG_UART
        port map(
            Clk     => Clk,
            Reset   => Reset,
            WrEn    => WrEn,
            Addr    => ALUout,
            E       => B,
            S       => UART_out,
            Go      => UART_go
        );

    -- Instance du REG_BENCH
    reg_bench_inst: REG_BENCH
        port map (
            Clk    => Clk,
            Reset  => Reset,
            W      => W,
            RA     => RA,
            RB     => MUX_Reg_out,
            RW     => RW,
            WE     => WE,
            A      => A,
            B      => B
        );

    -- Instance du ALU
    ual_inst: UAL port map (
        Reset => Reset,
        OP => OP,
        A => A,
        B => MUX_Im_out,
        S => ALUout,
        N => Flags(3),
        Z => Flags(2),
        C => Flags(1),
        V => Flags(0)
    );

    -- Instance du DATA_MEM
    data_mem_inst: DATA_MEM
        port map (
            Clk     => Clk,
            Reset   => Reset,
            DataIn  => B,
            DataOut => DataOut,
            Addr    => Addr,
            WrEn    => inf40
        );

    -- Instance du MUX Im
    muxIm_inst : MUX
        generic map (
            N => 32  -- Spécifie que les vecteurs doivent être de 32 bits (facultatif : par défaut 32)
        )
        port map (
            COM => COM_Mux_im,
            A => B,
            B => Im32,
            S => MUX_Im_out
        );

    -- Instance du MUX Reg
    mux_Reg_inst : MUX
        generic map (
            N => 4  -- Spécifie que les vecteurs doivent être de 32 bits (facultatif : par défaut 32)
        )
        port map (
            COM => WrEn,
            A => Rb,
            B => Rw,
            S => MUX_Reg_out
        );

    -- Instance du MUX out
    muxOut_inst : MUX
        generic map (
            N => 32  -- Spécifie que les vecteurs doivent être de 32 bits (facultatif : par défaut 32)
        )
        port map (
            COM => COM_Mux_out,
            A => ALUout,
            B => Dataout,
            S => W
        );

    -- Instance du SIGN_EXT
    signe_ext_inst : SIGN_EXT
        generic map (
            N => 8  -- 8 bits en entrée
        )
        port map (
            E => Im,
            S => Im32
        );

    -- Décodage d'adresse pour data Mem
    process(ALUout, WrEn)
    begin
        if ALUout(31 downto 6) = "00000000000000000000000000" then
            inf40 <= WrEn;
            Addr <= ALUout(5 downto 0);
        else
            inf40 <= '0';
            Addr <= "000000";
        end if;
    end process;

END architecture;