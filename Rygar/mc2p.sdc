
set_time_format -unit ns -decimal_places 3


create_clock -name {clock_50_i} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clock_50_i}]

derive_pll_clocks 
derive_clock_uncertainty

create_generated_clock -name SDRAM_CLK -source \
    [get_pins {pll|altpll_component|auto_generated|pll1|clk[1]}] \
    -divide_by 1 \
    [get_ports SDRAM_CLK]





create_clock -name {SPI_SCK}  -period 27.777 [get_ports {SPI_SCK}]


#**************************************************************
# Set Input Delay
#**************************************************************

# This is tAC in the data sheet. It is the time it takes to the
# output pins of the SDRAM to change after a new clock edge.
# This is used to calculate set-up time conditions in the FF
# latching the signal inside the FPGA
set_input_delay -clock SDRAM_CLK -max 6 [get_ports SDRAM_DQ[*]] 

# This is tOH in the data sheet. It is the time data is hold at the
# output pins of the SDRAM after a new clock edge.
# This is used to calculate hold time conditions in the FF
# latching the signal inside the FPGA (3.2)
set_input_delay -clock SDRAM_CLK -min 3 [get_ports SDRAM_DQ[*]]

#**************************************************************
# Set Output Delay
#**************************************************************

# This is tDS in the data sheet, setup time, spec is 1.5ns
set_output_delay -clock SDRAM_CLK -max 1.5 \
    [get_ports {SDRAM_A[*] SDRAM_BA[*] SDRAM_CKE SDRAM_DQMH SDRAM_DQML \
                SDRAM_DQ[*] SDRAM_nCAS SDRAM_nCS SDRAM_nRAS SDRAM_nWE}]
# This is tDH in the data sheet, hold time, spec is 0.8ns
set_output_delay -clock  SDRAM_CLK -min -0.8 \
    [get_ports {SDRAM_A[*] SDRAM_BA[*] SDRAM_CKE SDRAM_DQMH SDRAM_DQML \
                SDRAM_DQ[*] SDRAM_nCAS SDRAM_nCS SDRAM_nRAS SDRAM_nWE}]



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {SPI_SCK}] -group [get_clocks {*|altpll_component|auto_generated|pll1|clk[*]}]

#**************************************************************
# Set False Path
#**************************************************************


# Put constraints on input ports
set_false_path -from [get_ports {btn_*}] -to *

# Put constraints on output ports
set_false_path -from * -to [get_ports {LED*}]
set_false_path -from * -to [get_ports {VGA_*}]
set_false_path -from * -to [get_ports {AUDIO_L}]
set_false_path -from * -to [get_ports {AUDIO_R}]

