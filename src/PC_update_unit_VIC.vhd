library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC_UPDATE_UNIT_VIC is
    port(
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        nPCsel : in STD_LOGIC;
        Offset: in std_logic_vector (23 downto 0);
        LRen : in STD_LOGIC;
        VICPC: in std_logic_vector (31 downto 0);
        IRQ : in STD_LOGIC;
        IRQ_END : in STD_LOGIC;

        PC : out std_logic_vector (31 downto 0);
        IRQ_SERV : out STD_LOGIC
    );


end entity;

architecture RTL of PC_UPDATE_UNIT_VIC is

    component PC_REG
        port(
            Clk : STD_LOGIC;
            Reset : STD_LOGIC;
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0)
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

    component REG32 is
        port(
            Clk : in STD_LOGIC;
            Reset : in STD_LOGIC;
            WrEn : in STD_LOGIC;
            E: in std_logic_vector (31 downto 0);
            S: out std_logic_vector (31 downto 0)
        );
    end component;

    signal LRcom : std_logic;
    signal A, B, PC_ext, PC_in, PC_out, PC_reg_out, MuxOffOut, LRout : Std_Logic_Vector(31 downto 0) := (others => '0');
    signal A_int, B_int : integer := 0;

    begin

    LRcom <= IRQ or LRen;

    -- Instance du PC_REG
    inst_pcReg: PC_REG
        port map (
            Clk     => Clk,
            Reset   => Reset,
            E       => PC_in,
            S       => PC_reg_out
        );
    
    -- Instance du MUX offset
    muxOff_inst : MUX
        generic map (
            N => 32  -- Spécifie que les vecteurs doivent être de 32 bits (facultatif : par défaut 32)
        )
        port map (
            COM => nPCsel,
            A => A,
            B => B,
            S => MuxOffOut
        );

    -- Instance du MUX PC out
    muxPC_inst : MUX 
        generic map (
            N => 32  -- Spécifie que les vecteurs doivent être de 32 bits (facultatif : par défaut 32)
        )
        port map (
            COM => IRQ,
            A => PC_reg_out,
            B => VICPC,
            S => PC_out
        );

    -- Instance du MUX Plus one in
    muxLR_inst : MUX 
        generic map (
            N => 32  -- Spécifie que les vecteurs doivent être de 32 bits (facultatif : par défaut 32)
        )
        port map (
            COM => IRQ_END,
            A => MuxOffOut,
            B => LRout,
            S => PC_in
        );
    
    -- Instance du LR
    inst_LR : REG32
        port map(
            Clk => Clk,
            Reset => Reset,
            WrEn => LRcom,
            E => PC_reg_out,
            S => LRout
        );

    -- Instance du SIGN_EXT
    signe_ext_inst : SIGN_EXT
        generic map (
            N => 24  -- 24 bits en entrée
        )
        port map (
            E => Offset,
            S => PC_ext
        );

    A_int <= to_integer(signed(PC_out)) + 1;
    B_int <= to_integer(signed(PC_ext)) + A_int;

    A <= Std_Logic_Vector(to_signed(A_int, 32));
    B <= Std_Logic_Vector(to_signed(B_int, 32));

    PC <= PC_out;

    process(Clk)
    begin
        if rising_edge(Clk) then
            IRQ_SERV <= IRQ;
        end if;
    end process;

end architecture;