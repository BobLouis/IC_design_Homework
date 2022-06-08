library verilog;
use verilog.vl_types.all;
entity LZ77_Encoder is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        READ            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        CAL             : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        \OUT\           : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        SHIFT           : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        \OFFSET\        : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        \FINISH\        : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        chardata        : in     vl_logic_vector(7 downto 0);
        valid           : out    vl_logic;
        encode          : out    vl_logic;
        finish          : out    vl_logic;
        offset          : out    vl_logic_vector(4 downto 0);
        match_len       : out    vl_logic_vector(4 downto 0);
        char_nxt        : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ : constant is 1;
    attribute mti_svvh_generic_type of CAL : constant is 1;
    attribute mti_svvh_generic_type of \OUT\ : constant is 1;
    attribute mti_svvh_generic_type of SHIFT : constant is 1;
    attribute mti_svvh_generic_type of \OFFSET\ : constant is 1;
    attribute mti_svvh_generic_type of \FINISH\ : constant is 1;
end LZ77_Encoder;
