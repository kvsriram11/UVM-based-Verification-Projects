/*
-------------------------------------------------------------------------------
File        : mtx_transaction.sv
Class/Interface/Module : mtx_transaction
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Transaction class representing one matrix multiplication operation.
    It carries two 3x3 input matrices (A and B) that are randomized by the
    stimulus generation process, and stores the resulting matrix C observed
    from the DUT.

Responsibilities:
    - Represent a single matrix multiplication stimulus
    - Hold randomized input matrices A and B
    - Store output matrix C captured from the DUT
    - Serve as the data object passed between sequencer, driver,
      monitors, and scoreboard
-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_transaction extends uvm_sequence_item;

  // Factory registration
  `uvm_object_utils(mtx_transaction)

  // Input matrices driven to the DUT
  rand logic [15:0] A [2:0][2:0];
  rand logic [15:0] B [2:0][2:0];

  // Result matrix captured from the DUT
       logic [31:0] C [2:0][2:0];

  // Constructor
  function new(string name = "mtx_transaction");
    super.new(name);
  endfunction

endclass