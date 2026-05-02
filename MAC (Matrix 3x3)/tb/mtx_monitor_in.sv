import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_monitor_in extends uvm_monitor;

  `uvm_component_utils(mtx_monitor_in)

  virtual mtx_if vif;

  function new(string name="mtx_monitor_in", uvm_component parent);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);

    if(!uvm_config_db #(virtual mtx_if)::get(this,"","vif",vif))
      `uvm_fatal("MON_IN","Virtual interface not set")

  endfunction


  task run_phase(uvm_phase phase);

    forever begin

      @(posedge vif.start);

      `uvm_info("MON_IN","START detected",UVM_LOW)

      `uvm_info("MON_IN",
        $sformatf("A diag: %0h %0h %0h",
        vif.A[0][0],vif.A[1][1],vif.A[2][2]),
        UVM_LOW)

      `uvm_info("MON_IN",
        $sformatf("B diag: %0h %0h %0h",
        vif.B[0][0],vif.B[1][1],vif.B[2][2]),
        UVM_LOW)

    end

  endtask

endclass