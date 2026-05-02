/*
-------------------------------------------------------------------------------
File        : mtx_test.sv
Class/Interface/Module : mtx_test
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Top-level UVM test that builds the verification environment and
    launches the stimulus sequence. It retrieves the virtual interface
    from the testbench, creates the environment, performs reset, and
    starts the matrix multiplication stimulus.

Responsibilities:
    - Instantiate and configure the UVM environment
    - Provide the virtual interface to the environment
    - Start the stimulus sequence
    - Control simulation using UVM objections
-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_test extends uvm_test;

  `uvm_component_utils(mtx_test)

  mtx_env env;           // Verification environment
  virtual mtx_if vif;    // Interface handle from top module

  function new(string name="mtx_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction


  // Build phase: retrieve interface and create environment
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    `uvm_info("DEBUG","mtx_test build_phase executing",UVM_NONE)

    if (!uvm_config_db #(virtual mtx_if)::get(this,"","vif",vif))
      `uvm_fatal("TEST","Virtual interface not set")

    env = mtx_env::type_id::create("env",this);

    // Pass interface down to environment and its components
    uvm_config_db #(virtual mtx_if)::set(this,"env*","vif",vif);

  endfunction


  // Print UVM hierarchy after build/connect phases
  virtual function void end_of_elaboration_phase(uvm_phase phase);

    $display("DEBUG_ECE593: Printing UVM topology");

    uvm_top.print_topology();

  endfunction


  // Simulation banner for easier identification in logs
  virtual function void start_of_simulation_phase(uvm_phase phase);

    $display("DEBUG_ECE593: start_of_simulation_phase reached at time %0t", $time);

    `uvm_info("ECE593","  +==================================================================+",UVM_NONE)
    `uvm_info("ECE593","  |                                                                  |",UVM_NONE)
    `uvm_info("ECE593","  |   _____   ____  _____      ____    ___   _____                   |",UVM_NONE)
    `uvm_info("ECE593","  |  | ____| / ___|| ____|    | ___|  / _ \\ |___ /                   |",UVM_NONE)
    `uvm_info("ECE593","  |  |  _|  | |    |  _|      |___ \\ | (_) |  |_ \\                   |",UVM_NONE)
    `uvm_info("ECE593","  |  | |___ | |___ | |___      ___) | \\__, | ___) |                  |",UVM_NONE)
    `uvm_info("ECE593","  |  |_____| \\____||_____|    |____/    /_/ |____/                   |",UVM_NONE)
    `uvm_info("ECE593","  |                                                                  |",UVM_NONE)
    `uvm_info("ECE593","  +==================================================================+",UVM_NONE)

  endfunction


  // Run phase: apply reset and start stimulus
  task run_phase(uvm_phase phase);

    mtx_sequence seq;

    phase.raise_objection(this);

    `uvm_info("TEST","=================================================",UVM_LOW)
    `uvm_info("TEST","[TEST] Starting Matrix Multiplication Test",UVM_LOW)
    `uvm_info("TEST","=================================================",UVM_LOW)

    // Apply reset through driver
    env.drv.reset();

    // Start stimulus sequence
    seq = mtx_sequence::type_id::create("seq");
    seq.start(env.seqr);

    // Timeout protection
    #50000;

    `uvm_warning("TIMEOUT","Debug timeout reached")

    phase.drop_objection(this);

  endtask

endclass