library verilog;
use verilog.vl_types.all;
entity ELA is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        in_data         : in     vl_logic_vector(7 downto 0);
        data_rd         : in     vl_logic_vector(7 downto 0);
        req             : out    vl_logic;
        wen             : out    vl_logic;
        addr            : out    vl_logic_vector(9 downto 0);
        data_wr         : out    vl_logic_vector(7 downto 0);
        done            : out    vl_logic
    );
end ELA;
