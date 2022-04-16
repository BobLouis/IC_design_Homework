library verilog;
use verilog.vl_types.all;
entity LZ77_Encoder is
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
end LZ77_Encoder;
