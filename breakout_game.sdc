## Generated SDC file "car_parking.out.sdc"

## Copyright (C) 2022  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 21.1.1 Build 850 06/23/2022 SJ Lite Edition"

## DATE    "Fri Sep 30 14:47:47 2022"

##
## DEVICE  "EP4CE6E22C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 5.000 -waveform { 0.000 2.500 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {sw}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {btn[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {btn[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {reset_n}]

#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rgb[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rgb[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rgb[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {h_sync}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {v_sync}]
#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

