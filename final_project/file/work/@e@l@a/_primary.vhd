library verilog;
use verilog.vl_types.all;
entity ELA is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        ODD_RD_WR       : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        EVEN_RD         : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        EVEN_WR         : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        \DONE\          : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ready           : in     vl_logic;
        in_data         : in     vl_logic_vector(7 downto 0);
        data_rd         : in     vl_logic_vector(7 downto 0);
        req             : out    vl_logic;
        wen             : out    vl_logic;
        addr            : out    vl_logic_vector(12 downto 0);
        data_wr         : out    vl_logic_vector(7 downto 0);
        done            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of ODD_RD_WR : constant is 1;
    attribute mti_svvh_generic_type of EVEN_RD : constant is 1;
    attribute mti_svvh_generic_type of EVEN_WR : constant is 1;
    attribute mti_svvh_generic_type of \DONE\ : constant is 1;
end ELA;
