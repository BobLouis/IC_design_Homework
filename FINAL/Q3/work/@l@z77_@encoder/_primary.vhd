library verilog;
use verilog.vl_types.all;
entity LZ77_Encoder is
    generic(
        \IN\            : vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi0);
        ENCODE_NOT_MATCH: vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi1);
        ENCODE_MATCH    : vl_logic_vector(2 downto 0) := (Hi0, Hi1, Hi0);
        ENCODE_OUT      : vl_logic_vector(2 downto 0) := (Hi0, Hi1, Hi1);
        SHIFT_ENCODE    : vl_logic_vector(2 downto 0) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        chardata        : in     vl_logic_vector(7 downto 0);
        valid           : out    vl_logic;
        encode          : out    vl_logic;
        finish          : out    vl_logic;
        offset          : out    vl_logic_vector(3 downto 0);
        match_len       : out    vl_logic_vector(2 downto 0);
        char_nxt        : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of \IN\ : constant is 2;
    attribute mti_svvh_generic_type of ENCODE_NOT_MATCH : constant is 2;
    attribute mti_svvh_generic_type of ENCODE_MATCH : constant is 2;
    attribute mti_svvh_generic_type of ENCODE_OUT : constant is 2;
    attribute mti_svvh_generic_type of SHIFT_ENCODE : constant is 2;
end LZ77_Encoder;
