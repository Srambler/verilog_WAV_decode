transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/asic/Desktop/Music {C:/Users/asic/Desktop/Music/reg_config.v}
vlog -vlog01compat -work work +incdir+C:/Users/asic/Desktop/Music {C:/Users/asic/Desktop/Music/i2c_com.v}

vlog -vlog01compat -work work +incdir+C:/Users/asic/Desktop/Music/simulation/modelsim {C:/Users/asic/Desktop/Music/simulation/modelsim/reg_config.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  reg_config_vlg_tst

add wave *
view structure
view signals
run -all
