library verilog;
use verilog.vl_types.all;
entity i2c_com is
    port(
        clock_i2c       : in     vl_logic;
        reset_n         : in     vl_logic;
        ack             : out    vl_logic;
        i2c_data        : in     vl_logic_vector(23 downto 0);
        start           : in     vl_logic;
        tr_end          : out    vl_logic;
        i2c_sclk        : out    vl_logic;
        i2c_sdat        : inout  vl_logic
    );
end i2c_com;
