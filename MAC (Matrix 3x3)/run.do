# -----------------------------------------------------------------------------
# File        : run.do
# Project     : 3x3 Matrix Multiplier Verification Environment
# Course      : ECE-593 Fundamentals of Pre-Silicon Validation
# Author      : Venkata Sriram Kamarajugadda
# -----------------------------------------------------------------------------

# Save simulator transcript to a log file
transcript file simulation_log.txt
transcript on

# Clean previous simulation libraries
vdel -all
vlib work
vmap work work

# Compile RTL files with coverage and debug access
vlog -sv rtl/*.sv +cover=bcesf +acc

# Compile testbench package and supporting files
vlog -sv +incdir+tb tb/tb_pkg.sv
vlog -sv +incdir+tb tb/mtx_if.sv
vlog -sv +incdir+tb tb/top.sv +acc

# Launch simulation with coverage enabled
vsim -coverage -voptargs=+acc work.top \
     +UVM_TESTNAME=mtx_test \
     +UVM_VERBOSITY=UVM_LOW \
     -uvmcontrol=all

# Add all top-level signals to waveform viewer
add wave -r sim:/top/*

# Run simulation until completion
run -all

# Save coverage database
coverage save coverage.ucdb

# Generate coverage reports
coverage report -cvg -details -output functional_coverage.txt
coverage report -code bcesf -details -output code_coverage.txt

transcript off

puts {INFO: Reports generated: functional_coverage.txt, code_coverage.txt}