import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_agent extends uvm_agent;

  `uvm_component_utils(mtx_agent)

  mtx_sequencer seqr;
  mtx_driver drv;
  mtx_monitor mon;

  function new(string name="mtx_agent", uvm_component parent);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    seqr = mtx_sequencer::type_id::create("seqr",this);
    drv  = mtx_driver::type_id::create("drv",this);
    mon  = mtx_monitor::type_id::create("mon",this);

  endfunction


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(seqr.seq_item_export);

  endfunction

endclass