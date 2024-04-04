set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set ::env(DESIGN_NAME) {riscv_core}
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

set ::env(CLOCK_PERIOD) 20.000
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set ::env(BASE_SDC_FILE) "$::env(DESIGN_DIR)/src/riscv_base.sdc"

# SYNTHESIS - Flow
set ::env(SYNTH_AUTONAME) 0
set ::env(SYNTH_STRATEGY) "DELAY 0"
set ::env(SYNTH_BUFFERING) 1
set ::env(SYNTH_SIZING) 1
set ::env(SYNTH_SPLITNETS) 0
set ::env(IO_PCT) 0.2
set ::env(SYNTH_CAP_LOAD) 17.65
set ::env(SYNTH_MAX_FANOUT) 6
set ::env(SYNTH_MAX_TRAN) [ expr 0.1 * $::env(CLOCK_PERIOD) ]
set ::env(SYNTH_CLOCK_UNCERTAINTY) 0.25
set ::env(SYNTH_CLOCK_TRANSITION) 0.15
set ::env(SYNTH_TIMING_DERATE) 0.05


# FLOORPLAN
set ::env(FP_PDN_MULTILAYER) {1}
set ::env(FP_CORE_UTIL) 35
set ::env(FP_IO_MODE) 1

# PLACEMENT
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.10
set ::env(PL_RESIZER_SETUP_SLACK_MARGIN) 0.10
set ::env(GRT_ADJUSTMENT) 1

# Standard Cell Library specific variables
# SCL: Modifiable
set ::env(OUTPUT_CAP_LOAD) 17.65
set ::env(MAX_FANOUT_CONSTRAINT) 6
set ::env(MAX_TRANSITION_CONSTRAINT) [ expr 0.1 * $::env(CLOCK_PERIOD) ]
# SCL: Static
set ::env(SYNTH_DRIVING_CELL) sky130_fd_sc_hd__inv_8
set ::env(SYNTH_DRIVING_CELL_PIN) Y
set ::env(LIB_SYNTH) $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
set ::env(LIB_TYPICAL) $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
set ::env(LIB_SLOWEST) $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ss_n40C_1v28.lib
set ::env(LIB_FASTEST) $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__ff_100C_1v95.lib


set tech_specific_config "$::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl"
if { [file exists $tech_specific_config] == 1 } {
    source $tech_specific_config
}
