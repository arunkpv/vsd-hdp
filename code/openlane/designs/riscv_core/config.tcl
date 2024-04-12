# #############################################################################
#   config.tcl for riscv_core                                                 #
# #############################################################################

set ::env(PDK) "sky130A"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set ::env(DESIGN_NAME) {riscv_core}
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

set ::env(CLOCK_PERIOD) 10.000
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set ::env(BASE_SDC_FILE)    "$::env(DESIGN_DIR)/src/riscv_base_pre_cts.sdc"
set ::env(PNR_SDC_FILE)     "$::env(DESIGN_DIR)/src/riscv_base_post_cts.sdc"
set ::env(SIGNOFF_SDC_FILE) "$::env(DESIGN_DIR)/src/riscv_base_post_cts.sdc"

# SYNTHESIS - Flow
set ::env(SYNTH_AUTONAME) 0
set ::env(SYNTH_STRATEGY) "DELAY 4"
set ::env(SYNTH_BUFFERING) 1
set ::env(SYNTH_SIZING) 1
set ::env(SYNTH_SPLITNETS) 0
set ::env(IO_PCT) 0.20;                     # Default value: 0.20
set ::env(SYNTH_CLOCK_UNCERTAINTY) 0.50;    # Default value: 0.25
set ::env(SYNTH_CLOCK_TRANSITION) 0.20;     # Default value: 0.15
set ::env(SYNTH_TIMING_DERATE) 0.05;        # Default value: +/- 5%
# Following have been deprecated:
#set ::env(SYNTH_CAP_LOAD) 17.65
#set ::env(SYNTH_MAX_FANOUT) 6
#set ::env(SYNTH_MAX_TRAN) [ expr 0.1 * $::env(CLOCK_PERIOD) ]


# FLOORPLAN
set ::env(FP_CORE_UTIL) 30
set ::env(FP_IO_MODE) 1
set ::env(FP_PDN_MULTILAYER) {1}

# PLACEMENT
#set ::env(PL_TARGET_DENSITY) ($::env(FP_CORE_UTIL) + 10 + (5 * $::env(GPL_CELL_PADDING)) ) / 100.0
set ::env(PL_TARGET_DENSITY) 0.32
set ::env(PL_RESIZER_HOLD_SLACK_MARGIN) 0.20
set ::env(PL_RESIZER_SETUP_SLACK_MARGIN) 0.10

# CTS
set ::env(CTS_TOLERANCE) 5

# ROUTING
#set ::env(GRT_ADJUSTMENT) 1


# ##############################################################################
# sky130A_sky130_fd_sc_hd_config.tcl
# Mirroring here for visibility

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


set tech_specific_config "$::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl"
if { [file exists $tech_specific_config] == 1 } {
    source $tech_specific_config
}
