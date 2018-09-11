library verilog;
use verilog.vl_types.all;
entity reg_config is
    port(
        clock_50m       : in     vl_logic;
        i2c_sclk        : out    vl_logic;
        i2c_sdat        : inout  vl_logic;
        reset_n         : in     vl_logic
    );
end reg_config;
