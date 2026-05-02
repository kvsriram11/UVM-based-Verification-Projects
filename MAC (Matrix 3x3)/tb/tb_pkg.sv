/*
-------------------------------------------------------------------------------
File        : tb_pkg.sv
Class/Interface/Module : tb_pkg (Package)
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Testbench package that groups all UVM verification components used
    for the matrix multiplier environment. This package centralizes the
    compilation of transactions, sequences, drivers, monitors, scoreboard,
    environment, and test classes so they can be imported together.

Responsibilities:
    - Import UVM base library
    - Include all verification components
    - Provide a single package for testbench compilation
-------------------------------------------------------------------------------
*/

package tb_pkg;

  // Import UVM base classes and utilities
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Transaction definition
  `include "mtx_transaction.sv"

  // Sequence layer (stimulus generation)
  `include "mtx_sequence.sv"
  `include "mtx_sequencer.sv"

  // Driver that applies stimulus to the DUT
  `include "mtx_driver.sv"

  // Monitors observing DUT activity
  `include "mtx_monitor_in.sv"
  `include "mtx_monitor_out.sv"

  // Scoreboard for result checking
  `include "mtx_scoreboard.sv"

  // Environment assembling all components
  `include "mtx_env.sv"

  // Top-level test
  `include "mtx_test.sv"

endpackage