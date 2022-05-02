library verilog;
use verilog.vl_types.all;
entity LZ77_Decoder is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        code_pos        : in     vl_logic_vector(3 downto 0);
        code_len        : in     vl_logic_vector(2 downto 0);
        chardata        : in     vl_logic_vector(7 downto 0);
        encode          : out    vl_logic;
        finish          : out    vl_logic;
        char_nxt        : out    vl_logic_vector(7 downto 0)
    );
end LZ77_Decoder;
