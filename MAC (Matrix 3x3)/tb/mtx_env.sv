/*
-------------------------------------------------------------------------------
File        : mtx_env.sv
Class/Interface/Module : mtx_env
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    UVM environment that instantiates and connects the verification
    components used to test the matrix multiplier. It creates the
    sequencer, driver, monitors, and scoreboard, and establishes the
    communication between them.

Responsibilities:
    - Construct all verification components
    - Provide the virtual interface to driver and monitors
    - Connect sequencer to driver
    - Connect monitor output to the scoreboard
-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_env extends uvm_env;

  `uvm_component_utils(mtx_env)

  // Verification components
  mtx_sequencer     seqr;
  mtx_driver        drv;
  mtx_monitor_in    mon_in;
  mtx_monitor_out   mon_out;
  mtx_scoreboard    scb;

  // Virtual interface handle shared across components
  virtual mtx_if vif;


  // Constructor
  function new(string name="mtx_env", uvm_component parent=null);
    super.new(name,parent);
  endfunction


  // Build phase: create components and retrieve interface
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(virtual mtx_if)::get(this,"","vif",vif))
      `uvm_fatal("ENV","Virtual interface not set")

    seqr    = mtx_sequencer::type_id::create("seqr",this);
    drv     = mtx_driver::type_id::create("drv",this);
    mon_in  = mtx_monitor_in::type_id::create("mon_in",this);
    mon_out = mtx_monitor_out::type_id::create("mon_out",this);
    scb     = mtx_scoreboard::type_id::create("scb",this);

    // Provide interface to components that observe/drive DUT
    uvm_config_db #(virtual mtx_if)::set(this,"drv","vif",vif);
    uvm_config_db #(virtual mtx_if)::set(this,"mon_in","vif",vif);
    uvm_config_db #(virtual mtx_if)::set(this,"mon_out","vif",vif);

  endfunction


  // Connect phase: establish communication between components
  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    // Sequencer → Driver connection
    drv.seq_item_port.connect(seqr.seq_item_export);

    // Monitor output → Scoreboard connection
    mon_out.ap.connect(scb.scb_port);

  endfunction

endclass