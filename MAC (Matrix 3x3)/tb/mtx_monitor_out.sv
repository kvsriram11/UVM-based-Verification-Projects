/*
-------------------------------------------------------------------------------
File        : mtx_monitor_out.sv
Class/Interface/Module : mtx_monitor_out
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Output monitor that observes DUT activity through the interface.
    It captures the input matrices at the start of an operation and
    records the resulting matrix once the DUT asserts done.

Responsibilities:
    - Observe DUT control signals through the interface
    - Capture matrices A and B when a transaction begins
    - Capture result matrix C after computation completes
    - Send the collected transaction to the scoreboard via analysis port
-------------------------------------------------------------------------------
*/

class mtx_monitor_out extends uvm_monitor;

  `uvm_component_utils(mtx_monitor_out)

  // Virtual interface to observe DUT signals
  virtual mtx_if vif;

  // Analysis port used to send observed transactions to the scoreboard
  uvm_analysis_port #(mtx_transaction) ap;

  function new(string name="mtx_monitor_out", uvm_component parent);
    super.new(name,parent);
    ap = new("ap", this);
  endfunction

  // Get virtual interface from configuration database
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual mtx_if)::get(this,"","vif",vif))
      `uvm_fatal("MON","Virtual interface not set")
  endfunction


  task run_phase(uvm_phase phase);

    mtx_transaction tr;

    forever begin

      tr = new();

      // Transaction begins when start is asserted
      @(posedge vif.start);

      tr.A = vif.A;
      tr.B = vif.B;

      // Wait for computation to complete
      @(posedge vif.done);

      // Allow result pipeline to settle
      repeat(3) @(posedge vif.clk);

      tr.C = vif.C;

      // Send captured transaction to analysis subscribers
      ap.write(tr);

    end

  endtask

endclass