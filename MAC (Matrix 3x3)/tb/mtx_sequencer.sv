/*
-------------------------------------------------------------------------------
File        : mtx_sequencer.sv
Class/Interface/Module : mtx_sequencer
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Sequencer used in the UVM agent to coordinate the flow of
    mtx_transaction items from sequences to the driver.

Responsibilities:
    - Provide arbitration between sequences generating transactions
    - Forward mtx_transaction items to the driver through the
      sequencer-driver connection
-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_sequencer extends uvm_sequencer #(mtx_transaction);

  // Register with the UVM factory
  `uvm_component_utils(mtx_sequencer)

  // Constructor
  function new(string name="mtx_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction

endclass