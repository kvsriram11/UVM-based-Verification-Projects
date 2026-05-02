/*
-------------------------------------------------------------------------------
File        : mtx_driver.sv
Class/Interface/Module : mtx_driver
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Driver responsible for applying matrix transactions to the DUT through
    the interface. It receives mtx_transaction items from the sequencer and
    drives matrices A and B along with the start control signal.

Responsibilities:
    - Retrieve transactions from the sequencer
    - Drive input matrices to the DUT through the interface
    - Generate the start pulse for each operation
    - Wait for the DUT completion signal before issuing the next item
-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_driver extends uvm_driver #(mtx_transaction);

  `uvm_component_utils(mtx_driver)

  // Virtual interface handle used to access DUT signals
  virtual mtx_if vif;


  // Constructor
  function new(string name="mtx_driver", uvm_component parent);
    super.new(name,parent);
  endfunction


  // Retrieve virtual interface from UVM configuration database
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(virtual mtx_if)::get(this,"","vif",vif))
      `uvm_fatal("DRV","Virtual interface not set")

  endfunction


  // Applies reset to the DUT
  task reset();

    `uvm_info("DRV","Applying reset",UVM_LOW)

    vif.rst   <= 1;
    vif.start <= 0;

    vif.A <= '{default:'0};
    vif.B <= '{default:'0};

    repeat(5) @(posedge vif.clk);

    vif.rst <= 0;

    `uvm_info("DRV","Reset complete",UVM_LOW)

  endtask


  // Main driver activity
  task run_phase(uvm_phase phase);

    mtx_transaction pkt;

    // Initialize interface signals
    vif.start <= 0;
    vif.A <= '{default:'0};
    vif.B <= '{default:'0};

    forever begin

      // Get next transaction from sequencer
      seq_item_port.get_next_item(pkt);

      // Drive input matrices
      vif.A <= pkt.A;
      vif.B <= pkt.B;

      // Issue start pulse
      @(posedge vif.clk); #1;
      vif.start <= 1;

      @(posedge vif.clk); #1;
      vif.start <= 0;

      // Wait for DUT to assert done
      @(posedge vif.done);

      // Allow pipeline to flush before next item
      repeat(4) @(posedge vif.clk);

      `uvm_info("DRV","Transaction completed",UVM_LOW)

      seq_item_port.item_done();

    end

  endtask

endclass