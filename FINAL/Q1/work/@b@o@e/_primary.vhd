library verilog;
use verilog.vl_types.all;
entity BOE is
    generic(
        IDLE            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        READ            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        WRITE_MAX       : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        WRITE_SUM       : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        WRITE_SORT      : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_num        : in     vl_logic_vector(2 downto 0);
        data_in         : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(10 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of READ : constant is 1;
    attribute mti_svvh_generic_type of WRITE_MAX : constant is 1;
    attribute mti_svvh_generic_type of WRITE_SUM : constant is 1;
    attribute mti_svvh_generic_type of WRITE_SORT : constant is 1;
end BOE;
