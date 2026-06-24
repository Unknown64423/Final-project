## ====================================================================
## Basys 3 FPGA Hardware Constraints File (.xdc)
## For RISC-V Memory-Mapped I/O Project
## ====================================================================

## --------------------------------------------------------------------
## 1. 系統時脈 (System Clock) - 100MHz
## --------------------------------------------------------------------
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
## --------------------------------------------------------------------
## 2. 指撥開關 (Switches) - SW0 ~ SW3
## --------------------------------------------------------------------
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]

## --------------------------------------------------------------------
## 3. LED 燈 (LEDs) - LED0 ~ LED3
## --------------------------------------------------------------------
set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

## --------------------------------------------------------------------
## 4. 七段顯示器 燈條訊號 (7 Segment Display Segments) - CA ~ CG
## --------------------------------------------------------------------
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

## --------------------------------------------------------------------
## 5. 七段顯示器 致能訊號 (7 Segment Display Anodes) - AN0 ~ AN3
## --------------------------------------------------------------------
set_property PACKAGE_PIN U2 [get_ports {an[0]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN L1 [get_ports {an[3]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

## --------------------------------------------------------------------
## 6. 中央按鈕 (Buttons) - btnC 用作系統 Reset
## --------------------------------------------------------------------
set_property PACKAGE_PIN T18 [get_ports btnC]						
set_property IOSTANDARD LVCMOS33 [get_ports btnC]

